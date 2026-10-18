"""Read-only integrity check for the farmer's installed RGBA animation frames."""
from pathlib import Path
import json
from PIL import Image

root = Path(__file__).resolve().parents[1]
catalog = json.loads((root / 'art/fazendeiro_fiel/catalog.json').read_text(encoding='utf-8'))
frames = 0
for state, data in catalog.items():
    assert len(data['frames']) == len(data['durations_ms']), state
    assert all(duration > 0 for duration in data['durations_ms']), state
    for resource in data['frames']:
        path = root / resource.removeprefix('res://')
        with Image.open(path) as im:
            assert im.mode == 'RGBA' and im.size == (128, 128), path
            alpha = im.getchannel('A')
            assert set(alpha.tobytes()) == {0, 255}, path
            box = alpha.getbbox()
            assert box and box[0] >= 2 and box[1] >= 2 and box[2] <= 126 and box[3] <= 126, (path, box)
        frames += 1
    gif = root / f'docs/arte_fazendeiro_fiel/previas/{state}/{state}.gif'
    with Image.open(gif) as im:
        assert im.size == (512, 512) and im.n_frames == len(data['frames']), gif
    validation = json.loads((gif.parent / 'validation.json').read_text(encoding='utf-8'))
    assert validation['passed'] and not any(f['severity'] in ('error', 'warning') for f in validation['findings']), state
    print(f'{state}: {len(data["frames"])} frames, {sum(data["durations_ms"])} ms, RGBA and margins OK')
print(f'PASS: {frames} installed frames; 6 GIF previews; 6 Aseprite validations')
