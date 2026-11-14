#!/usr/bin/env python3
"""Captura sesiones reales de ib-tools (es/en) para la terminal animada de la web."""
import json, os, re, subprocess, tempfile, pexpect, sys
REPO = sys.argv[1]
OUT = sys.argv[2]
PROFILE = {
 'es': dict(n='Ana García López', e='ana.garcia@ejemplo.edu', u='Universidad de Ejemplo', c='Escuela de Ingeniería', t='Grado en Informática', a='Programación'),
 'en': dict(n='Alex Morgan', e='alex.morgan@example.edu', u='Example University', c='School of Engineering', t='BSc Computer Science', a='Programming'),
}
def setup(lang):
    tmp = tempfile.mkdtemp(prefix='ibweb-')
    home = os.path.join(tmp, 'home')
    os.makedirs(os.path.join(home, '.config', 'ib-tools'))
    p = PROFILE[lang]
    with open(os.path.join(home, '.config/ib-tools/config'), 'w') as f:
        f.write(f"IB_LANG={lang}\nIB_NOMBRE='{p['n']}'\nIB_EMAIL={p['e']}\nIB_UNIVERSIDAD='{p['u']}'\nIB_CENTRO='{p['c']}'\nIB_TITULACION='{p['t']}'\nIB_ASIGNATURA='{p['a']}'\nIB_CURSO=2026-2027\n")
    with open(os.path.join(home, '.config/ib-tools/version'), 'w') as f: f.write('1.2.0\n')
    env = dict(os.environ, HOME=home, PATH=f"{REPO}/bin:/usr/local/bin:/usr/bin:/bin", NO_COLOR='1', TERM='dumb', LANG='C.UTF-8')
    os.makedirs(os.path.join(home, 'practicas'))
    return home, env

def clean(text, home):
    text = text.replace('\r\n', '\n').replace('\r', '')
    return text.replace(home, '/home/alumno')

def to_lines(text):
    lines = []
    for ln in text.split('\n'):
        m = re.match(r'^(.*?)\x01(.*)\x02$', ln)
        if m: lines.append({'p': m.group(1), 'a': m.group(2)})
        else: lines.append(ln)
    while lines and lines[-1] == '': lines.pop()
    return lines

def inter(cwd, cmd, steps, env, home):
    c = pexpect.spawn('/bin/bash', ['-c', cmd], cwd=cwd, env=env, encoding='utf-8', echo=False, dimensions=(50, 200), timeout=30)
    t = ''
    for pat, ans in steps:
        c.expect(pat); t += c.before + c.after + f'\x01{ans}\x02\n'; c.sendline(ans)
    c.expect(pexpect.EOF); t += c.before; c.close()
    return to_lines(clean(t, home))

def sh(cwd, cmd, env, home):
    r = subprocess.run(cmd, shell=True, cwd=cwd, env=env, text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    return to_lines(clean(r.stdout, home))

def edit(path, old, new):
    s = open(path, encoding='utf-8').read(); assert old in s, (path, old); open(path, 'w', encoding='utf-8').write(s.replace(old, new, 1))

data = {}
for lang in ('es', 'en'):
    home, env = setup(lang)
    prac = os.path.join(home, 'practicas')
    es = lang == 'es'
    y = 's' if es else 'y'
    name = 'cuadrado' if es else 'square'
    arg = 'numero' if es else 'number'
    desc = 'calcula el cuadrado de un número' if es else 'computes the square of a number'
    S = {}
    S['nuevo'] = inter(prac, f'nuevo {name}', [
        (r'(principal|main program).*: ', ''),
        (r'\[(s/N|y/N)\] ', y),
        (r'(funciones|functions file) \(.*: ', ''),
        (r'\[(s/N|y/N)\] ', y),
        (r'(argumentos|arguments).*: ', ''),
        (r'(argumento|argument) 1.*: ', arg),
        (r'(programa|program do)\?.*: ', desc),
        (r'\[(S/n|Y/n)\] ', ''),
    ], env, home)
    ej = os.path.join(prac, name)
    S['ls'] = sh(ej, 'ls', env, home)
    S['head'] = sh(ej, f'head -n 13 {name}_main.cc', env, home)
    S['main'] = sh(ej, f'tail -n +14 {name}_main.cc', env, home)
    S['wc'] = sh(ej, 'wc -l Makefile *.cc *.h', env, home)
    S['makefile'] = sh(ej, 'grep -E "^(PROGRAMA|MAIN|CXXFLAGS|clean:)" Makefile', env, home)
    # el alumno completa el programa
    fn = 'Cuadrado' if es else 'Square'
    edit(f'{ej}/{name}_main.cc', '#include <iostream>', '#include <cstdlib>\n#include <iostream>')
    edit(f'{ej}/{name}_main.cc', '  return 0;', f'  const int {arg}{{std::atoi(argv[1])}};\n  std::cout << {arg} << "^2 = " << {fn}({arg}) << std::endl;\n\n  return 0;')
    edit(f'{ej}/{name}.h', '#endif', f'// {"Devuelve el cuadrado de un número." if es else "Returns the square of a number."}\nint {fn}(int {arg});\n\n#endif')
    with open(f'{ej}/{name}.cc', 'a', encoding='utf-8') as f:
        f.write(f'\n// {"Devuelve el cuadrado de un número." if es else "Returns the square of a number."}\nint {fn}(int {arg}) {{ return {arg} * {arg}; }}\n')
    S['run_noarg'] = sh(ej, 'run', env, home)
    S['run'] = sh(ej, 'run 7', env, home)
    S['estilo_ok'] = sh(ej, 'estilo', env, home)
    demo = os.path.join(prac, 'demo'); os.makedirs(demo)
    with open(f'{demo}/{"mal" if es else "messy"}.cc', 'w') as f:
        f.write(f'#include <iostream>\nusing namespace std;\nint {fn}(int n){{\n  int {"sin_usar" if es else "unused"};\n  return n*n;\n}}\nint main(){{\n  cout<<{fn}(4)<<endl;\n}}\n')
    S['estilo_bad'] = sh(demo, 'estilo', env, home)
    S['estilo_f'] = sh(demo, 'estilo -f', env, home)
    S['config'] = sh(prac, 'ib-config --ver' if es else 'ib-config --show', env, home)
    S['version'] = sh(prac, 'ib-update --version', env, home)
    S['genmake_y'] = sh(os.path.join(prac), f'mkdir rapido && cd rapido && genmake rapido -y' if es else 'mkdir quick && cd quick && genmake quick -y', env, home)
    data[lang] = S
json.dump(data, open(OUT, 'w'), ensure_ascii=False, indent=1)
print('ok')
