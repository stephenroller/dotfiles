#!/usr/bin/env python
import sys, re, os

HOSTNAME = os.popen('hostname').read()[:-1]
HOME = os.environ['HOME']
USER = os.environ['USER']

COLORS = {
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
    'alicia': 'Blue',
    'mshawking.asmallorange.com': 'Purple',
    'cheddar': 'Red'
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

color = COLORS[HOST_COLORS.get(HOSTNAME, 'Black')]
path = shortest_name(os.getcwd())
print '\\[\\033[%sm\\]%s \\[\\033[00m\\]%s' % (color, USER, path),
