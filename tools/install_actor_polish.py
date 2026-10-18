"""Copy native Aseprite exports without changing pixels; generate the runtime catalog."""
from pathlib import Path
import json, shutil

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT.parent / 'sprite-tools/actor-polish'
TARGET = ROOT / 'art/atores_polidos'
DOCS = ROOT / 'docs/polimento_atores'
TARGET.mkdir(parents=True, exist_ok=True)
DOCS.mkdir(parents=True, exist_ok=True)
(DOCS / '.gdignore').touch()
catalog = json.loads((SOURCE / 'catalog.json').read_text(encoding='utf-8'))
count = 0
for entity, states in catalog.items():
    for state, data in states.items():
        assert isinstance(data['offset'], list) and len(data['offset']) == 2
        folder = SOURCE / entity / state
        archive = DOCS / entity / state
        archive.mkdir(parents=True, exist_ok=True)
        for frame in data['frames']:
            shutil.copy2(folder / Path(frame).name, TARGET / Path(frame).name)
            count += 1
        for name in [f'{entity}_{state}.aseprite', 'filmstrip.png', 'preview.gif', 'validation.json']:
            if (folder / name).exists():
                shutil.copy2(folder / name, archive / name)
for name in ['catalog.json', 'sources.json']:
    shutil.copy2(SOURCE / name, DOCS / name)
payload = json.dumps(catalog, ensure_ascii=False, indent=2).replace('true', 'true').replace('false', 'false')
(ROOT / 'actor_polish_data.gd').write_text('extends RefCounted\n\n# Native Aseprite exports; no combat attributes.\nconst DATA: Dictionary = ' + payload + '\n', encoding='utf-8')
print(f'Installed {count} PNG frames, {sum(len(s) for s in catalog.values())} cycles, {len(catalog)} families')
