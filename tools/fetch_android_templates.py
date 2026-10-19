"""Fetch only Android source from the official Godot TPZ via HTTP ranges."""
from pathlib import Path
import io, json, struct, urllib.request, zipfile, zlib

OUT = Path(__file__).resolve().parents[2] / 'android-tools' / 'godot-4.7.2'
OUT.mkdir(parents=True, exist_ok=True)
API = 'https://api.github.com/repos/godotengine/godot/releases/tags/4.7.2-stable'
HEADERS = {'User-Agent': 'Fazendeiro-Android-Build', 'Cache-Control': 'no-cache'}
with urllib.request.urlopen(urllib.request.Request(API, headers=HEADERS), timeout=60) as response:
    release = json.load(response)
asset = next(a for a in release['assets'] if a['name'] == 'Godot_v4.7.2-stable_export_templates.tpz')
URL, SIZE = asset['browser_download_url'], asset['size']

def read_range(start, length):
    if not length: return b''
    request = urllib.request.Request(URL, headers={**HEADERS, 'Range': f'bytes={start}-{start+length-1}'})
    with urllib.request.urlopen(request, timeout=300) as response:
        if response.status != 206:
            raise RuntimeError(f'Expected ranged response, got {response.status}')
        content_range = response.headers.get('Content-Range', '')
        if not content_range.startswith(f'bytes {start}-'):
            raise RuntimeError(f'Incorrect range: {content_range}')
        data = response.read()
    assert len(data) == length, (start, length, len(data))
    return data

class RemoteZip(io.RawIOBase):
    def __init__(self): self.pos = 0
    def seekable(self): return True
    def seek(self, offset, whence=0):
        self.pos = offset if whence == 0 else self.pos + offset if whence == 1 else SIZE + offset
        return self.pos
    def tell(self): return self.pos
    def read(self, length=-1):
        length = SIZE-self.pos if length < 0 else min(length, SIZE-self.pos)
        data = read_range(self.pos, length)
        self.pos += len(data)
        return data

with zipfile.ZipFile(RemoteZip()) as archive:
    entries = [i for i in archive.infolist() if i.filename.endswith('/android_source.zip')]
    for info in entries:
        target = OUT / Path(info.filename).name
        if target.exists() and target.stat().st_size == info.file_size and zlib.crc32(target.read_bytes()) == info.CRC:
            print('Already verified:', target, flush=True)
            continue
        print('Downloading Android template only:', info.filename, info.compress_size, 'bytes', flush=True)
        header = read_range(info.header_offset, 30)
        assert header[:4] == b'PK\x03\x04'
        name_length, extra_length = struct.unpack_from('<HH', header, 26)
        compressed = read_range(info.header_offset+30+name_length+extra_length, info.compress_size)
        payload = zlib.decompress(compressed, -15) if info.compress_type == 8 else compressed
        assert len(payload) == info.file_size and zlib.crc32(payload) == info.CRC
        target.write_bytes(payload)
        print('Verified:', target, len(payload), flush=True)
        with zipfile.ZipFile(target) as template:
            print('Template entries:', len(template.infolist()), flush=True)
    assert entries, 'Android source template missing'
