"""Read-only audio measurements. No instrument recognition or listening claims.

Dependencies live outside the Godot project in ../audio-tools/python.
"""
from pathlib import Path
import sys
ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT.parent / 'audio-tools/python'))
import hashlib
import json
import re
import subprocess
import numpy as np
import soundfile as sf
import imageio_ffmpeg
from scipy import signal

FFMPEG = imageio_ffmpeg.get_ffmpeg_exe()
OUT = ROOT / 'docs/trilha_country'

def decode(path, rate=22050, channels=1):
    data = subprocess.check_output([FFMPEG, '-v', 'error', '-i', str(path),
        '-f', 'f32le', '-ac', str(channels), '-ar', str(rate), '-'])
    return np.frombuffer(data, '<f4').reshape(-1, channels)

def measure(path):
    x = decode(path)[:, 0]
    rate = 22050
    # Spectral flux in overlapping 46 ms windows, autocorrelation tempo candidates.
    _, times, z = signal.stft(x, fs=rate, nperseg=1024, noverlap=768)
    mag = np.abs(z)
    flux = np.maximum(np.diff(mag, axis=1), 0).sum(axis=0)
    flux -= np.mean(flux)
    ac = signal.correlate(flux, flux, mode='full', method='fft')[len(flux)-1:]
    fps = rate / 256
    low, high = int(fps*60/185), int(fps*60/65)
    peaks, _ = signal.find_peaks(ac[low:high])
    lags = sorted(peaks + low, key=lambda i: ac[i], reverse=True)[:4]
    tempo = [{'bpm': round(60*fps/i, 1), 'autocorrelation': round(float(ac[i]/max(ac[0],1e-12)), 3)} for i in lags]
    # Pitch-class energy is only an approximation on a full polyphonic mix.
    freq, _, zz = signal.stft(x[::2], fs=rate/2, nperseg=4096, noverlap=2048)
    valid = (freq > 65) & (freq < 2000)
    midi = np.rint(69 + 12*np.log2(freq[valid]/440)).astype(int)
    chroma = np.bincount(midi % 12, weights=np.abs(zz[valid]).sum(axis=1), minlength=12)
    chroma /= max(chroma.sum(), 1e-12)
    keys = []
    for mode, profile in [('maior',[6.35,2.23,3.48,2.33,4.38,4.09,2.52,5.19,2.39,3.66,2.29,2.88]),
                          ('menor',[6.33,2.68,3.52,5.38,2.60,3.53,2.54,4.75,3.98,2.69,3.34,3.17])]:
        for tonic in range(12):
            keys.append((float(np.corrcoef(chroma,np.roll(profile,tonic))[0,1]),
                         ['C','C#','D','Eb','E','F','F#','G','Ab','A','Bb','B'][tonic]+' '+mode))
    keys.sort(reverse=True)
    loud = subprocess.run([FFMPEG,'-hide_banner','-i',str(path),'-af',
        'loudnorm=I=-18:TP=-2:LRA=11:print_format=json','-f','null','-'],capture_output=True,text=True)
    match = re.search(r'\{\s*"input_i".*?\}', loud.stderr, re.S)
    blocks = [float(np.sqrt(np.mean(x[a:a+rate]**2))) for a in range(0,len(x)-rate,rate)]
    return {'file':str(path),'sha256':hashlib.sha256(path.read_bytes()).hexdigest(),
        'duration_seconds':round(len(x)/rate,3),
        'tempo_candidates_not_confirmed':tempo,
        'key_candidates_not_confirmed':[{'key':k,'correlation':round(c,3)} for c,k in keys[:3]],
        'loudness':json.loads(match.group()) if match else {},
        'rms_1s_percentiles':np.percentile(blocks,[10,50,90]).round(5).tolist(),
        'analysis_limit':'Technical measurements only. Tempo can be half/double; key is uncertain. No automatic instrument or vocal identification.'}

if __name__ == '__main__':
    OUT.mkdir(parents=True,exist_ok=True)
    inputs = [Path(r'C:/Users/artur/Downloads/Harvest_of_Thorns.mp3'),
              Path(r'C:/Users/artur/Downloads/Sunday_Morning_Porch_Swing__1_.mp3'),
              ROOT/'audio/music_gameplay.ogg',ROOT/'audio/music_map_celeiro.ogg',ROOT/'audio/music_hub.wav']
    result=[]
    for path in inputs:
        entry=measure(path)
        result.append(entry)
        print(json.dumps(entry,ensure_ascii=False),flush=True)
    # Check whether in-game encodes correspond to user references without copying either.
    matches=[]
    for a in inputs[:2]:
        aa=decode(a,rate=4000)[:,0]
        for b in inputs[2:4]:
            bb=decode(b,rate=4000)[:,0]
            n=min(len(aa),len(bb),4000*90)
            a0=aa[:n].astype(float); b0=bb[:n].astype(float)
            c=signal.correlate(a0,b0,mode='full',method='fft')
            center=n-1; radius=4000*5
            lag=int(np.argmax(np.abs(c[center-radius:center+radius+1])))-radius
            if lag>=0:
                av,bv=a0[lag:],b0[:n-lag]
            else:
                av,bv=a0[:n+lag],b0[-lag:]
            corr=float(np.corrcoef(av,bv)[0,1])
            matches.append({'reference':a.name,'game':b.name,'best_pcm_correlation':round(corr,5),
                            'reference_lag_seconds':lag/4000})
    (OUT/'analise_referencias.json').write_text(json.dumps({'files':result,'correspondence':matches},ensure_ascii=False,indent=2),encoding='utf-8')
