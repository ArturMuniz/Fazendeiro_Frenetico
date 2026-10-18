"""Independent checks of delivered encodes, MIDI integrity and untouched sources."""
from pathlib import Path
import sys
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT.parent/'audio-tools/python'))
import hashlib
import json
import numpy as np
import soundfile as sf
import mido
from analyze_music import decode, measure
from compose_country import loudness, OUT, SR

checks=[]
def check(condition,label):
    checks.append({'passed':bool(condition),'description':label})
    print(('PASS ' if condition else 'FAIL ')+label,flush=True)

manifest=json.loads((OUT/'manifesto.json').read_text(encoding='utf-8'))
references=json.loads((OUT/'analise_referencias.json').read_text(encoding='utf-8'))
for source in references['files']:
    p=Path(source['file'])
    check(hashlib.sha256(p.read_bytes()).hexdigest()==source['sha256'],f'Original preservado: {p.name}')
for s in manifest['tracks']:
    ident=s['id'];mid=mido.MidiFile(OUT/'midi'/f'{ident}.mid')
    active={};balanced=True;notes=0;elapsed=0
    for msg in mid:
        elapsed+=msg.time
        if msg.type=='note_on' and msg.velocity:
            k=(msg.channel,msg.note);active[k]=active.get(k,0)+1;notes+=1
        elif msg.type=='note_off' or msg.type=='note_on' and msg.velocity==0:
            k=(msg.channel,msg.note);active[k]=active.get(k,0)-1
            balanced &= active[k]>=0
    check(balanced and all(n==0 for n in active.values()),f'{ident}: MIDI sem notas presas')
    check(notes>300 and abs(elapsed-s['duration_seconds'])<.002,f'{ident}: composição completa e duração MIDI')
    for rel,expected in s['files'].items():
        check(hashlib.sha256((OUT/rel).read_bytes()).hexdigest()==expected,f'{ident}: integridade {Path(rel).suffix}')
    x,rate=sf.read(OUT/'loops'/f'{ident}.ogg',always_2d=True)
    check(rate==SR and x.shape==(s['frames'],2),f'{ident}: OGG estéreo e comprimento do loop')
    check(np.isfinite(x).all() and abs(x).max()<1,f'{ident}: amostras válidas sem clipping')
    seam=np.abs(x[0]-x[-1]).max()
    check(seam<.02,f'{ident}: descontinuidade de emenda {seam:.6f}')
    stats=loudness(OUT/'loops'/f'{ident}.ogg')
    check(float(stats['input_tp'])<=-1.5 and -25<float(stats['input_i'])<-15,f'{ident}: pico verdadeiro e loudness')
    mono=x.mean(axis=1)
    check(np.sqrt(np.mean(mono**2))/np.sqrt(np.mean(x**2))>.85,f'{ident}: compatibilidade mono')
    mp3=decode(OUT/'previas'/f'{ident}.mp3',rate=SR,channels=2)
    check(abs(len(mp3)/SR-s['duration_seconds'])<.15 and np.isfinite(mp3).all(),f'{ident}: prévia MP3 decodifica inteira')
report={'checks':len(checks),'failures':sum(not c['passed'] for c in checks),'results':checks,
        'limitation':'Technical validation only; no listening approval, Android playback test, or musical quality rating.'}
(OUT/'validacao.json').write_text(json.dumps(report,ensure_ascii=False,indent=2),encoding='utf-8')
print(f'RESULT checks={report["checks"]} failures={report["failures"]}',flush=True)
sys.exit(1 if report['failures'] else 0)
