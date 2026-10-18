"""Original MIDI sketches + sampled audio, rendered offline with FluidSynth.

No source-audio fragments are sampled. General MIDI steel/nylon guitar is an
arrangement proxy for viola caipira, not an authentic recorded viola instrument.
Dependencies and sound bank remain outside the game in ../audio-tools.
"""
from pathlib import Path
import sys
ROOT = Path(__file__).resolve().parents[1]
TOOLS = ROOT.parent / 'audio-tools'
sys.path.insert(0, str(TOOLS/'python'))
import hashlib
import json
import math
import random
import re
import shutil
import subprocess
import numpy as np
import soundfile as sf
import mido
from scipy import signal
from analyze_music import FFMPEG

OUT = ROOT/'docs/trilha_country'
WORK = TOOLS/'renders'
FONT = TOOLS/'soundfonts/GeneralUser-GS.sf2'
SR = 44100
TPB = 960

# Chord voicings for hand-authored melodies. Degrees are diatonic, zero based.
CHORDS = {
 'C':(48,[60,64,67]), 'F':(41,[60,65,69]), 'G':(43,[59,62,67]),
 'Am':(45,[60,64,69]), 'D':(50,[62,66,69]), 'Em':(40,[59,64,67]),
 'A':(45,[61,64,69]), 'Bm':(47,[59,62,66]), 'B7':(47,[59,63,66,69]),
}
SCORES = [
 dict(id='01_varanda_de_domingo',name='Varanda de Domingo',role='Lobby',bpm=104,key='C maior',tonic=60,
      scale=[0,2,4,5,7,9,11],style='porch',chords=['C','C','F','C','Am','F','G','G'],
      bridge=['Am','F','C','G','F','C','G','G'],sections='AABA',
      phrases=['4:1 2:.5 1:.5 0:1 R:1','0:.5 2:.5 4:1 5:.5 4:.5 2:1',
               '3:1 5:.5 4:.5 3:1 2:1','2:.5 1:.5 0:2 R:1',
               '5:1 4:.5 2:.5 0:1 2:1','3:.5 5:.5 4:1 3:.5 2:.5 0:1',
               '1:1 2:.5 4:.5 3:1 1:1','1:.5 2:.5 1:1 4:1 R:1']),
 dict(id='02_mutirao_na_horta',name='Mutirão na Horta',role='Horta',bpm=150,key='G maior',tonic=67,
      scale=[0,2,4,5,7,9,11],style='drive',chords=['G','G','C','G','Em','C','D','D'],
      bridge=['C','C','G','G','Em','C','D','D'],sections='AABACA',
      phrases=['0:.5 2:.5 4:.5 2:.5 1:.5 0:.5 2:1','4:.5 5:.5 4:1 2:.5 1:.5 0:1',
               '3:.5 5:.5 7:1 5:.5 4:.5 3:1','4:.5 2:.5 1:.5 0:.5 2:1 R:1',
               '5:.5 4:.5 2:1 0:.5 2:.5 4:1','3:.5 4:.5 5:.5 3:.5 2:1 0:1',
               '1:.5 3:.5 4:1 6:.5 4:.5 3:1','1:1 4:.5 3:.5 1:1 R:1']),
 dict(id='03_catira_do_celeiro',name='Catira do Celeiro',role='Celeiro',bpm=104,key='C maior',tonic=60,
      scale=[0,2,4,5,7,9,11],style='shuffle',chords=['C','F','C','G','Am','F','G','G'],
      bridge=['F','F','C','Am','F','C','G','G'],sections='AABA',
      phrases=['0:.5 2:.5 4:1 R:.5 2:.5 0:1','3:.5 5:.5 7:1 5:.5 4:.5 3:1',
               '4:1 2:.5 0:.5 2:1 R:1','1:.5 2:.5 4:1 3:.5 1:.5 -1:1',
               '0:1 2:.5 5:.5 4:1 2:1','3:.5 5:.5 4:.5 3:.5 2:1 0:1',
               '1:.5 3:.5 4:1 3:.5 1:.5 -1:1','1:1 4:1 1:1 R:1']),
 dict(id='04_estrada_do_pomar',name='Estrada do Pomar',role='Pomar',bpm=124,key='D maior / B menor',tonic=62,
      scale=[0,2,4,6,7,9,11],style='orchard',chords=['D','A','Bm','G','D','G','A','A'],
      bridge=['Bm','G','D','A','Bm','G','A','A'],sections='AABACA',
      phrases=['4:1 2:.5 1:.5 0:1 2:1','1:1 -1:.5 1:.5 4:1 R:1',
               '5:1 4:.5 2:.5 0:1 2:1','3:1 2:.5 0:.5 -2:1 R:1',
               '0:.5 2:.5 4:1 5:.5 4:.5 2:1','3:.5 5:.5 4:1 3:1 0:1',
               '1:.5 3:.5 4:1 6:.5 4:.5 3:1','1:1 -1:1 1:1 R:1']),
 dict(id='05_colheita_bravia',name='Colheita Bravia',role='Chefe',bpm=156,key='E menor',tonic=64,
      scale=[0,2,3,5,7,8,10],style='boss',chords=['Em','Em','C','G','Am','C','B7','B7'],
      bridge=['Am','C','Em','Em','C','Am','B7','B7'],sections='AABACA',
      phrases=['0:.5 0:.5 2:.5 4:.5 3:1 2:1','0:.5 2:.5 4:1 6:.5 4:.5 2:1',
               '5:.5 4:.5 2:1 0:.5 2:.5 4:1','2:1 4:.5 6:.5 4:1 R:1',
               '3:.5 3:.5 5:1 4:.5 3:.5 2:1','5:.5 4:.5 2:1 0:1 2:1',
               '1:.5 3:.5 4:1 6:.5 4:.5 3:1','1:1 4:.5 3:.5 1:1 R:1']),
]

class Arrangement:
    def __init__(self, spec):
        self.s=spec; self.rng=random.Random(spec['id']); self.events=[]
        self.bars=len(spec['sections'])*8; self.beats=self.bars*4
    def pitch(self, degree):
        octave,ix=divmod(degree,7)
        return self.s['tonic']+12*octave+self.s['scale'][ix]
    def note(self,ch,pitch,beat,duration,velocity=75,loose=True):
        jitter=self.rng.uniform(-.009,.009)*self.s['bpm']/60 if loose else 0
        start=max(0,beat+jitter); end=min(self.beats,start+duration)
        if start>=self.beats or end<=start:return
        vel=max(1,min(127,velocity+self.rng.randint(-5,5)))
        self.events.extend([(start,mido.Message('note_on',channel=ch,note=pitch,velocity=vel)),
                            (end,mido.Message('note_off',channel=ch,note=pitch,velocity=0))])
    def chord(self,ch,notes,beat,duration,velocity):
        order=list(notes)
        if int(beat*2)%2:order.reverse()
        for i,p in enumerate(order):self.note(ch,p,beat+i*.013,duration,velocity-i*2)
    def compose(self):
        s=self.s; busy=s['style'] in ('drive','boss'); gentle=s['style']=='porch'
        for bar in range(self.bars):
            section=s['sections'][bar//8]; local=bar%8; base=bar*4
            chordname=(s['bridge'] if section in 'BC' else s['chords'])[local]
            bass,voicing=CHORDS[chordname]
            # Root/fifth two-beat foundation; passing tones only at turnarounds.
            for b,p in [(0,bass-12),(2,bass-5)]:self.note(2,p,base+b,1.35 if gentle else .7,72 if gentle else 87)
            if local==7:
                for b,p in [(3,bass-12),(3.5,bass-10)]:self.note(2,p,base+b,.32,66)
            # Boom-chuck steel or fingerstyle guitar, independently voiced.
            if gentle:
                pattern=[(0,0),(.5,1),(1,2),(1.5,1),(2,0),(2.5,2),(3,1),(3.5,2)]
                for b,i in pattern:self.note(0,voicing[i],base+b,.74,61 if b%1 else 72)
            else:
                self.note(0,bass,base,.4,75); self.note(0,bass+7,base+2,.4,71)
                for b in [1,3]:self.chord(0,voicing,base+b,.3,61 if not busy else 73)
                if s['style']=='shuffle':
                    for b in [.66,2.66]:self.chord(0,voicing,base+b,.17,43)
            # Banjo rolls are chord tones, with space for the lead instrument.
            if not gentle or section=='B':
                roll=[0,1,2,0,2,1,0,2]
                if section=='C':roll=[2,1,0,2,0,1,2,1]
                density=16 if busy else 8
                for k in range(density):
                    if not busy and k%3==1:continue
                    p=voicing[roll[k%8]]+12
                    self.note(1,p,base+k*4/density,.21 if busy else .35,51 if busy else 44)
            # Explicit eight-bar melody. B answers the main motif; C is sparser.
            cursor=0
            tokens=s['phrases'][local].split()
            leadch=4 if gentle or s['style']=='shuffle' else 3
            if section=='B':leadch=3 if leadch==4 else 4
            if section=='C':leadch=4
            for ix,token in enumerate(tokens):
                degree,dur=token.split(':'); duration=float(dur)
                if degree!='R':
                    d=int(degree)
                    if section=='B':d+=2 if local%2==0 else -2
                    if section=='C' and ix%2:cursor+=duration;continue
                    pitch=self.pitch(d)
                    # Harmonic minor dominant at the boss turnaround.
                    if chordname=='B7' and pitch%12==2:pitch+=1
                    # Land strong beats on nearby chord tones; keep passing notes free.
                    if cursor in (0,2):
                        candidates=[p+o for p in voicing for o in (-12,0,12,24)]
                        pitch=min(candidates,key=lambda p:abs(p-pitch))
                    swing=.11 if s['style']=='shuffle' and cursor%1==.5 else 0
                    self.note(leadch,pitch,base+cursor+swing,duration*.82,74 if gentle else 82)
                    if s['style'] in ('shuffle','orchard') and duration>=1 and section!='C':
                        self.note(5,self.pitch(d-2),base+cursor+.025,duration*.75,44)
                cursor+=duration
            assert abs(cursor-4)<.0001,(s['id'],local,cursor)
            # Dry percussion; softer lobby, shuffle claps and restrained fills.
            for b in range(4):
                if not gentle:self.note(9,36,base+b,.12,76 if b%2==0 else 43,False)
                if b%2==1:self.note(9,37 if gentle else 38,base+b,.1,36 if gentle else 64,False)
                if not gentle and s['style']=='shuffle':self.note(9,39,base+b,.09,37,False)
                if not gentle or section=='B':
                    self.note(9,42,base+b,.065,35 if gentle else 43,False)
                    self.note(9,42,base+b+(.66 if s['style']=='shuffle' else .5),.065,29,False)
            if local==7 and not gentle:
                for k,drum in enumerate([38,45,47,38]):self.note(9,drum,base+3+k*.25,.1,45+k*4,False)
        return self
    def save(self,path,repeats=1):
        mid=mido.MidiFile(ticks_per_beat=TPB)
        track=mido.MidiTrack();mid.tracks.append(track)
        track.append(mido.MetaMessage('track_name',name=self.s['name']))
        track.append(mido.MetaMessage('set_tempo',tempo=mido.bpm2tempo(self.s['bpm'])))
        track.append(mido.MetaMessage('time_signature',numerator=4,denominator=4))
        # Program, volume, pan: guitar, banjo, bass, fiddle, harmonica, double-string proxy.
        programs={0:25,1:105,2:32,3:110,4:22,5:24,9:0}
        for ch,program in programs.items():
            track.append(mido.Message('program_change',channel=ch,program=program))
            for ctrl,value in [(7,{0:90,1:76,2:100,3:72,4:71,5:58,9:82}[ch]),
                               (10,{0:46,1:84,2:64,3:70,4:57,5:82,9:64}[ch]),(91,0),(93,0)]:
                track.append(mido.Message('control_change',channel=ch,control=ctrl,value=value))
        events=[]
        for cycle in range(repeats):
            for t,msg in self.events:events.append((round((t+cycle*self.beats)*TPB),msg))
        # Note-off precedes note-on for repeated pitches at the same tick.
        events.sort(key=lambda e:(e[0],e[1].type=='note_on'))
        last=0
        for tick,msg in events:
            track.append(msg.copy(time=tick-last));last=tick
        track.append(mido.MetaMessage('end_of_track',time=max(0,round(self.beats*repeats*TPB)-last)))
        mid.save(path)

def run(args):
    p=subprocess.run([str(a) for a in args],capture_output=True,text=True)
    if p.returncode:raise RuntimeError(p.stderr[-2500:]+p.stdout[-2500:])
    return p

def loudness(path):
    p=run([FFMPEG,'-hide_banner','-i',path,'-af','loudnorm=I=-18:TP=-2:LRA=11:print_format=json','-f','null','-'])
    return json.loads(re.search(r'\{\s*"input_i".*?\}',p.stderr,re.S).group())

def render(arr):
    s=arr.s; ident=s['id']; renderdir=WORK/ident;renderdir.mkdir(parents=True,exist_ok=True)
    midi=OUT/'midi'/f'{ident}.mid';arr.save(midi)
    repeated=renderdir/'three_cycles.mid';arr.save(repeated,3)
    fluid=next((TOOLS/'fluidsynth').rglob('fluidsynth.exe'))
    raw=renderdir/'raw.wav'
    run([fluid,'-n','-i','-q','-r',SR,'-g','.45','-R','0','-C','0',
         '-o','synth.cpu-cores=1','-F',raw,'-T','wav',FONT,repeated])
    audio,sr=sf.read(raw,dtype='float32',always_2d=True)
    tempo=mido.bpm2tempo(s['bpm'])
    seconds=arr.beats*tempo/1e6
    frames=round(seconds*SR)
    # Use the middle cycle to carry note releases across a mathematically fixed loop.
    x=audio[frames:frames*2].copy()
    assert len(x)==frames and sr==SR
    x=signal.sosfilt(signal.butter(2,40,fs=SR,btype='highpass',output='sos'),x,axis=0)
    # Short circular room taps: no tail is discarded at the loop boundary.
    dry=x.copy()
    for delay,gain in [(.029,.055),(.047,.04),(.083,.025)]:
        x+=np.roll(dry,round(delay*SR),axis=0)[:,::-1]*gain
    center=x.mean(axis=1,keepdims=True);x=center+(x-center)*.7
    # Five-ms zero-edge taper preserves exact bar count and avoids waveform steps.
    n=round(.005*SR);ramp=np.sin(np.linspace(0,np.pi/2,n))**2
    x[:n]*=ramp[:,None];x[-n:]*=ramp[::-1,None]
    pre=renderdir/'premaster.wav';sf.write(pre,x,SR,subtype='PCM_24')
    measured=loudness(pre)
    gain=min(-18-float(measured['input_i']),-2.3-float(measured['input_tp']))
    x*=10**(gain/20)
    master=renderdir/f'{ident}_master.wav';sf.write(master,x,SR,subtype='PCM_24')
    preview=OUT/'previas'/f'{ident}.mp3'
    ogg=OUT/'loops'/f'{ident}.ogg'
    run([FFMPEG,'-y','-v','error','-i',master,'-c:a','libmp3lame','-b:a','192k',preview])
    run([FFMPEG,'-y','-v','error','-i',master,'-c:a','libvorbis','-q:a','5',
         '-metadata',f'title={s["name"]}','-metadata',f'LOOPSTART=0','-metadata',f'LOOPEND={frames}',ogg])
    y,ysr=sf.read(ogg,always_2d=True)
    stats=loudness(ogg)
    # Technical gate; this does not replace the user's artistic listening review.
    checks={'stereo_44100':ysr==SR and y.shape[1]==2,
      'loop_length_exact':len(y)==frames,'finite':bool(np.isfinite(y).all()),
      'no_clipping':float(np.max(np.abs(y)))<1,
      'true_peak_below_minus_1_5':float(stats['input_tp'])<=-1.5,
      'audible_level':-25<float(stats['input_i'])<-15,
      'seam_step_below_0_02':float(np.max(np.abs(y[0]-y[-1])))<.02,
      'no_empty_seconds':all(np.sqrt(np.mean(y[i:i+SR]**2))>.003 for i in range(0,len(y)-SR,SR))}
    if not all(checks.values()):raise RuntimeError((ident,checks))
    record={**s,'bars':arr.bars,'duration_seconds':round(seconds,3),'frames':frames,
      'loudness_lufs':float(stats['input_i']),'true_peak_dbtp':float(stats['input_tp']),
      'stereo_correlation':round(float(np.corrcoef(y.T)[0,1]),3),
      'seam_step':round(float(np.max(np.abs(y[0]-y[-1]))),6),'checks':checks,
      'files':{str(p.relative_to(OUT)):hashlib.sha256(p.read_bytes()).hexdigest() for p in [midi,preview,ogg]},
      'production_status':'Sampled MIDI arrangement demo. Not approved as final game music; no critical listening by the agent.'}
    print(json.dumps({k:record[k] for k in ['id','duration_seconds','loudness_lufs','true_peak_dbtp','checks']},ensure_ascii=False),flush=True)
    return record

if __name__=='__main__':
    for sub in ['midi','loops','previas','licencas']:(OUT/sub).mkdir(parents=True,exist_ok=True)
    WORK.mkdir(parents=True,exist_ok=True)
    (OUT/'.gdignore').write_text('')
    records=[]
    for spec in SCORES:records.append(render(Arrangement(spec).compose()))
    shutil.copy2(TOOLS/'soundfonts/LICENSE-GeneralUser-GS.txt',OUT/'licencas/GeneralUser-GS.txt')
    provenance={'soundfont':{'url':'https://github.com/mrbumpy409/GeneralUser-GS','sha256':hashlib.sha256(FONT.read_bytes()).hexdigest()},
      'renderer':'FluidSynth 2.6.1 official Windows x64 build','sample_rate':SR,
      'source_audio_fragments_used':False,'human_listening_pending':True,'tracks':records}
    (OUT/'manifesto.json').write_text(json.dumps(provenance,ensure_ascii=False,indent=2),encoding='utf-8')
