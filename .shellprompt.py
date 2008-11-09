#!/usr/bin/env python
import sys, re, os

MAXPWD = 18
HOSTNAME = os.popen('hostname').read()[:-1]
HOME = os.environ['HOME']
user = os.environ['USER']

COLORS = {
    'Default': '0;00',
    'Black': '0;30',
    'Blue': '0;34',
    'Green': '0;32',
    'Cyan': '0;36',
    'Red': '0;31',
    'Purple': '0;35',
    'Brown': '0;33',
    'Light Gray': '0;37',
    'Dark Gray': '1;30',
    'Light Blue': '1;34',
    'Light Green': '1;32',
    'Light Cyan': '1;36',
    'Light Red': '1;31',
    'Light Purple': '1;35',
    'Yellow': '1;33',
    'White': '1;37',
}

HOST_COLORS = {
    'faith.local': 'Light Red',
    'neuace.tenniscores.com': 'Green',
    'mshawking.asmallorange.com': 'Purple',
    'cheddar': 'Brown'
}

def shortest_name(path):
    path = path.replace(HOME, '~')
    base = os.path.basename(path)
    path = os.path.dirname(path)
    def make_sub(match):
        full_word = match.groups()[0]
        files = os.listdir(make_sub.p)
        n = 1
        while True:
            word = full_word[0:n]
            if len([s for s in files if s.startswith(word)]) == 1 or \
                word == full_word:
                    make_sub.p = os.path.join(make_sub.p, full_word)
                    return '/%s' % word
            n += 1
    make_sub.p = path.startswith('~/') and HOME + '/' or '/'
    
    return os.path.join(re.sub(r'/([^/]+)', make_sub, path), base)

if __name__ == '__main__':
    shell = []
    
    color = COLORS[HOST_COLORS.get(HOSTNAME, 'Default')]
    if user == 'stephen': 
        user = 'sr'
    shell.append('\\[\\033[%sm\\]%s ' % (color, user))
    
    try:
        path = shortest_name(os.getcwd())
    except:
        try:
            path = os.getcwd()
        except:
            path = '\\[\\033[0;31m\\]\W'
    if len(path) > MAXPWD: 
        base = os.path.basename(os.getcwd())
        if len(base) > MAXPWD:
            path = base[0:5] + '...' + base[-3:]
        else:
            path = base
    shell.append('\\[\\033[00m\\]%s ' % path)
    
    exitcode = sys.argv[1]
    prompt = (user == "root" and "#" or "$")
    color = (exitcode == "0" and COLORS['Light Green'] or COLORS['Light Red'])
    shell.append('\\[\\033[%sm\\]%s ' % (color, prompt))
    shell.append('\\[\\033[00m\\]')
    print "".join(shell),
