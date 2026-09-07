"""Verify/restore a lossless candidate transport archive; never execute members.

Default: verify only. --output requires a fresh directory; --repository-root
supplies already-stored canonical aliases. No network or mathematical replay.
"""
from __future__ import annotations
import argparse
import base64
import hashlib
import json
import lzma
from pathlib import Path, PurePosixPath

LIMIT = 8 * 1024 * 1024
PREFIXES = ('research/artifacts/candidates/', 'research/artifacts/source-notes/')

def require(ok: bool, message: str) -> None:
    if not ok:
        raise ValueError(message)

def relative(name: str) -> Path:
    p = PurePosixPath(name)
    require(not p.is_absolute() and '..' not in p.parts and '\\' not in name,
            'Unsafe relative member path')
    require(p.as_posix() == name and name.startswith(PREFIXES),
            'Member outside candidate surface')
    return Path(*p.parts)

def bounded_read(path: Path) -> bytes:
    require(path.is_file() and not path.is_symlink(), 'Missing or symlink input')
    require(path.stat().st_size <= LIMIT, 'Input size cap exceeded')
    return path.read_bytes()

def check_bytes(raw: bytes, row: dict, size_key: str = 'bytes',
                hash_key: str = 'sha256') -> None:
    require(len(raw) == row[size_key], 'Byte count mismatch')
    require(hashlib.sha256(raw).hexdigest() == row[hash_key], 'SHA256 mismatch')

def verify(directory: Path, repository_root: Path | None = None,
           output: Path | None = None) -> dict:
    manifest_raw = bounded_read(directory / 'manifest.json')
    manifest = json.loads(manifest_raw)
    require(manifest['format'] == 'opg500-lossless-text-archive-v1', 'Unknown format')
    parts = []
    for row in manifest['chunks']:
        name = row['path']
        require(Path(name).name == name, 'Unsafe chunk name')
        raw = bounded_read(directory / name)
        check_bytes(raw, row)
        parts.append(b''.join(raw.split()))
    packed = base64.b64decode(b''.join(parts), validate=True)
    check_bytes(packed, manifest, 'compressed_bytes', 'compressed_sha256')
    expected = manifest['uncompressed_json_bytes']
    require(0 <= expected <= LIMIT, 'Decoded size cap exceeded')
    decoder = lzma.LZMADecompressor(memlimit=128*1024*1024)
    raw = decoder.decompress(packed, max_length=expected+1)
    require(decoder.eof and not decoder.unused_data, 'Incomplete or trailing archive')
    check_bytes(raw, manifest, 'uncompressed_json_bytes', 'uncompressed_json_sha256')
    members = json.loads(raw)
    require(isinstance(members, dict), 'Expected path-to-text object')
    listed = {r['path'] for r in manifest['members']
              if r['storage'] == 'lossless_archive_member'}
    require(set(members) == listed, 'Archive coverage mismatch')
    require(len(manifest['members']) == manifest['original_file_count'], 'Count mismatch')
    materialized = {}
    for row in manifest['members']:
        name = row['path']
        relative(name)
        require(name not in materialized, 'Duplicate member')
        if row['storage'] == 'lossless_archive_member':
            require(isinstance(members[name], str), 'Nontext member')
            data = members[name].encode('utf-8')
        else:
            require(row['storage'] == 'existing_repository_file', 'Unknown storage')
            require(repository_root is not None, 'Repository root needed for alias')
            canonical = relative(row['canonical_path'])
            resolved_root = repository_root.resolve()
            target = repository_root / canonical
            require(target.resolve().is_relative_to(resolved_root), 'Alias escape')
            data = bounded_read(target)
        check_bytes(data, row)
        data.decode('utf-8', 'strict')
        materialized[name] = data
    if output is not None:
        require(not output.exists() and not output.is_symlink(), 'Output must be new')
        output.mkdir(parents=True, exist_ok=False)
        for name, data in materialized.items():
            destination = output / relative(name)
            destination.parent.mkdir(parents=True, exist_ok=True)
            with destination.open('xb') as stream:
                stream.write(data)
    return {'verdict': 'candidate_only', 'scope': 'transport_byte_integrity_only',
            'mathematical_execution': 'not_performed',
            'manifest_sha256': hashlib.sha256(manifest_raw).hexdigest(),
            'members_checked': len(materialized),
            'member_bytes': sum(map(len, materialized.values())),
            'aliases': manifest['existing_alias_count'],
            'extracted': output is not None}

if __name__ == '__main__':
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('directory', type=Path)
    p.add_argument('--repository-root', type=Path)
    p.add_argument('--output', type=Path)
    a = p.parse_args()
    print(json.dumps(verify(a.directory, a.repository_root, a.output), sort_keys=True))
