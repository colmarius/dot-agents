import sys,re
for p in sys.argv[1:]:
    out=[];skip=False
    for line in open(p,encoding='utf-8'):
        if line.startswith('### '):
            skip = line.strip()=='### .agents/work/AGENTS.md'
        if not skip: out.append(line)
    print(''.join(out))
