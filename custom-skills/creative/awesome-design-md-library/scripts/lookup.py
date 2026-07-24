#!/usr/bin/env python3
from pathlib import Path
import argparse, re, sys
LIB = Path('~/.hermes-venv/skill-libraries/awesome-design-md')

def norm(s): return re.sub(r'[^a-z0-9]+',' ',s.lower()).strip()
items=[]
for p in sorted(LIB.glob('*/DESIGN.md')):
    slug=p.parent.name
    text=p.read_text(encoding='utf-8', errors='ignore')
    first=' '.join(text.split()[:80])
    items.append((slug,p,first,text))
parser=argparse.ArgumentParser(description='Search local awesome-design-md library')
parser.add_argument('query', nargs='*')
parser.add_argument('--list', action='store_true')
parser.add_argument('--path', action='store_true')
parser.add_argument('--limit', type=int, default=10)
args=parser.parse_args()
if args.list:
    for slug,_,_,_ in items: print(slug)
    sys.exit(0)
q=norm(' '.join(args.query))
if not q:
    print(f'library={LIB}\nobsidian={OBS}\ncount={len(items)}')
    sys.exit(0)
scored=[]
terms=q.split()
for slug,p,first,text in items:
    hay=norm(slug+' '+first+' '+text[:4000])
    score=sum(5 if t in norm(slug) else 1 for t in terms if t in hay)
    if score: scored.append((score,slug,p,first))
scored.sort(reverse=True)
for score,slug,p,first in scored[:args.limit]:
    if args.path:
        print(f'{slug}\t{p}')
    else:
        print(f'{slug}\t{score}\t{p}\n  {first[:220]}')
