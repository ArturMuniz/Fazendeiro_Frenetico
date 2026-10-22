"""Verify all delivered runtime PNGs against the approved integration ledger."""
from pathlib import Path
import hashlib
import json
import struct

repo = Path(__file__).resolve().parents[1]
ledger = json.loads((repo / "docs/integracao_hd/assets_manifest.json").read_text(encoding="utf-8"))
count = 0
for path, expected in list(ledger["actors"].items()) + [(v["path"],v["sha256"]) for v in ledger["maps"].values()]:
    file = repo / path.removeprefix("res://")
    content = file.read_bytes()
    assert hashlib.sha256(content).hexdigest() == expected, str(file)
    assert content[:8] == b"\x89PNG\r\n\x1a\n", str(file)
    width, height = struct.unpack(">II", content[16:24])
    assert width > 0 and height > 0
    count += 1
print(f"ASSETS PASS {count} PNGs verified by SHA-256, no raster changes")
