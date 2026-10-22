"""Copy approved finished PNGs; preserve their pixels and clip durations."""
from pathlib import Path
import argparse
import hashlib
import json
import shutil

parser = argparse.ArgumentParser()
parser.add_argument("--workspace", type=Path, default=Path(__file__).resolve().parents[2])
args = parser.parse_args()
repo = Path(__file__).resolve().parents[1]
source = args.workspace / "Sprites_Remodelados"
catalog = json.loads((source / "catalogo_integracao.json").read_text(encoding="utf-8"))
manifest = {"actors": {}, "maps": {}}
integrated = {}
for actor, clips in catalog.items():
    integrated[actor] = {}
    for state, clip in clips.items():
        frames = []
        for index, relative in enumerate(clip["frames"]):
            original = source / relative
            dest = repo / "art" / "atores_integrados" / actor / state / f"{index:02}.png"
            dest.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(original, dest)
            path = "res://" + dest.relative_to(repo).as_posix()
            frames.append(path)
            manifest["actors"][path] = hashlib.sha256(dest.read_bytes()).hexdigest()
        integrated[actor][state] = {
            "frames": frames, "durations_ms": clip["durations_ms"],
            "fps": len(frames) * 1000.0 / sum(clip["durations_ms"]),
            "loop": clip["loop"], "offset": clip["offset"],
        }
(repo / "integrated_actor_data.gd").write_text(
    "extends RefCounted\n\n## Approved whole-frame animations, imported without raster edits.\nconst DATA: Dictionary = "
    + json.dumps(integrated, ensure_ascii=False, indent="\t") + "\n", encoding="utf-8")
for map_id, folder, filename in [
    ("horta", "Previa_Mobile_Soja_20261021", "mapa_soja_plate.png"),
    ("celeiro", "Previa_Mobile_Celeiro_20261021", "mapa_celeiro_plate.png"),
    ("pomar", "Previa_Mobile_Pomar_20261021", "mapa_pomar_plate.png"),
]:
    dest = repo / "art" / "arenas" / f"{map_id}.png"
    dest.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(args.workspace / folder / filename, dest)
    manifest["maps"][map_id] = {"path": "res://" + dest.relative_to(repo).as_posix(),
                                "sha256": hashlib.sha256(dest.read_bytes()).hexdigest()}
docs = repo / "docs" / "integracao_hd"
docs.mkdir(parents=True, exist_ok=True)
(docs / "assets_manifest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
shutil.copyfile(source / "PROMPTS.md", docs / "PROMPTS_ATORES.md")
for name, folder in [("SOJA", "Soja"), ("CELEIRO", "Celeiro"), ("POMAR", "Pomar")]:
    shutil.copyfile(args.workspace / f"Previa_Mobile_{folder}_20261021" / "PROMPT_BACKGROUND.md", docs / f"PROMPT_{name}.md")
print(f"Imported {len(integrated)} actors, {sum(len(c) for c in integrated.values())} clips, {len(manifest['actors'])} frames, 3 maps")
