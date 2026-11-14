#!/usr/bin/env python3
"""Genera docs/index.html a partir de site/template.html.

  python3 site/capture.py "$PWD" site/sessions.json   # (opcional) vuelve a capturar las sesiones reales
  python3 site/build.py                                # escribe docs/index.html
"""
import json, os
here = os.path.dirname(os.path.abspath(__file__))
root = os.path.dirname(here)
t = open(os.path.join(here, 'template.html'), encoding='utf-8').read()
sessions = json.load(open(os.path.join(here, 'sessions.json'), encoding='utf-8'))
changelog = json.load(open(os.path.join(here, 'changelog.json'), encoding='utf-8'))
version = open(os.path.join(root, 'VERSION')).read().strip()
t = t.replace('/*SESSIONS*/null', json.dumps(sessions, ensure_ascii=False, separators=(',', ':')).replace('</', '<\\/'))
t = t.replace('/*CHANGELOG*/null', json.dumps(changelog, ensure_ascii=False, separators=(',', ':')).replace('</', '<\\/'))
t = t.replace('/*VERSION*/', version)
t = t.replace('la versión VERSION', f'la versión {version}')
open(os.path.join(root, 'docs', 'index.html'), 'w', encoding='utf-8').write(t)
print('docs/index.html', len(t), 'bytes, versión', version)
