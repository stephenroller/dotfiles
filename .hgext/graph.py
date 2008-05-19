#!/usr/bin/env python

import os
import pdb
from itertools import izip
from mercurial import hg, util
from mercurial.node import short
from mercurial.changelog import nullid
from PIL import Image, ImageDraw, ImageFont

GRID_SIZE = 25
PADDING = 10
RADIUS = 5
FONT = '/Users/stephen/Library/Fonts/consola.ttf'
FONT_SIZE = 10

def px(*coords):
    return tuple(PADDING + c*GRID_SIZE for c in coords)

def color(depth):
    colors = [  (0, 0, 0),
                (192, 0, 0),
                (0, 192, 0),
                (0, 0, 192),  
                (192, 192, 0),
                (192, 0, 192),
                (0, 192, 192), ]
    
    choice = depth % len(colors)
    turns = depth / len(colors)
    add = turns*255/3.
    return tuple(int(min(add + x, 255)) for x in colors[choice])

def bestx(parent, linehistory, revnums):
    if len(linehistory) == 0: return 0
    parentno = revnums[parent]
    lines = linehistory[-1]
    
    for history in linehistory[parentno+1:]:
        for i,x in enumerate(history):
            if lines[i]: continue
            lines[i] = x
    # print lines
    for x,holder in enumerate(lines): 
        if holder == parent: return x
    for x,holder in enumerate(lines):
        if holder == None: return x
    return len(lines)
    
               
class Graph:
    def __init__(self):
        self.x = {nullid: 0}
        self.y = {nullid: 0}
        self.label = {}
        self.connections = []
    
    def save(self, filename):
        def _addpairs(*pairs):
            return map(sum, zip(*pairs))
        
        def _normalize(x, y):
            if x != 0: x /= abs(x)
            if y != 0: y /= abs(y)
            return x, y
        
        def _scale(c, l):
            return tuple(c * t for t in l)
        
        def _line(canvas, coords, color):
            canvas.line(px(*coords), fill=color)
        
        def _arrow(canvas, coords, color):
            _line(canvas, coords, color)
            xa, ya, xb, yb = coords
            
            tip = px(*coords[2:])
            shift = xa - xb, ya - yb
            shift = _normalize(*shift)
            tip = _addpairs(tip, _scale(RADIUS+1, shift))
            base = _addpairs(tip, _scale(RADIUS-1, shift))
            coor1 = _addpairs(base, _scale(RADIUS-1, shift[::-1]))
            coor2 = _addpairs(base, _scale(-RADIUS+1, shift[::-1]))
            
            canvas.line(tip + coor1, fill=color)
            canvas.line(tip + coor2, fill=color)
        
        size = max(self.x.values()), max(self.y.values())
        textx = px(*size)[0] + 2 * PADDING
        size = _addpairs(px(*size), (PADDING+500, PADDING))
        
        im = Image.new(mode='RGBA', size=size)
        draw = ImageDraw.Draw(im)
        draw.setfont(ImageFont.truetype(FONT, FONT_SIZE))
        
        for a,b in reversed(self.connections):
            xa, ya = self.x[a], self.y[a]
            try: 
                xb, yb = self.x[b], self.y[b]
            except:
                pass
            clr = color([xa, xb][xa < xb])
            if xa <= xb:
                # a branch, draw the arrow right then down
                _line(draw, (xa, ya) + (xb, ya), color(xb))
                if xa != xb:
                    _arrow(draw, (xb, ya) + (xb, yb), color(xb))
                else:
                    _line(draw, (xb, ya) + (xb, yb), color(xb))
            else:
                # a merge, draw the arrow down, then left
                _line(draw, (xa, ya) + (xa, yb), color(xa))
                _arrow(draw, (xa, yb) + (xb, yb), color(xa))
        
        points = ((k,self.x[k],v) for k,v in self.y.iteritems())
        for rev,x,y in points:
            if rev == nullid: continue
            depth, revno = x, y
            x, y = px(x, y)
            a = (x - RADIUS, y - RADIUS)
            b = (x + RADIUS, y + RADIUS)
            draw.ellipse(a + b, fill=color(depth))
            label = self.label.get(rev, '')
            draw.text((textx, y - RADIUS), label, fill=color(depth))
        
        try:
            bbox = im.getbbox()[2:]
            size = _addpairs(bbox, (2*PADDING, 2*PADDING))
            newim = Image.new('RGB', size, color=(255, 255, 255))
            newim.paste(im, (PADDING, PADDING), im)
            im = newim
        except:
            pass
        
        f = file(filename, 'w')
        im.save(f, "PNG")
        f.close()
    
    def connect(self, a, b):
        self.connections.append((a, b))
    
    def plot(self, name, x, y, label=""):
        self.x[name] = x
        self.y[name] = y
        self.label[name] = label

def generate_graph(ui, repo, start, finish):
    def _strbranches(branches):
        s = []
        for rev in branches:
            if rev:
                s.append(short(rev))
            else: 
                s.append('X')
        return str(s)
    
    def _freebranch(branches):
        for i, rev in enumerate(branches):
            if rev == None: return i
        return len(branches)
    
    def _treewidth(branches):
        for i, rev in reversed(tuple(enumerate(branches))):
            if rev: 
                return i+1
        return -1
    
    def _trim(l):
        if l == []: return []
        x = len(l) - 1
        while x >= 0 and l[x] == None:
            x -= 1
        return l[:x+1]
    
    log = repo.changelog
    datanames = ('rev', 'user', 'timestamp', 'changes', 'message', 'extra')
    
    getdata = lambda x: dict(izip(datanames, log.read(x)))
    datestr = lambda x: util.datestr(x, timezone=False)
    
    history = []
    branches = [nullid]
    revnos = {nullid: 0}
    graph = Graph()
    revisions, bases, heads = log.nodesbetween(start, finish)
    for revno, rev in enumerate(revisions):
        revnos[rev] = revno
        
        parent1, parent2 = log.parents(rev)
        if parent1 not in graph.x: parent1 = nullid
        if parent2 not in graph.x: parent2 = nullid
        
        if parent2 != nullid:
            # two parents, merge    
            # parent1 is always closer to the origin
            parent1, parent2 = sorted((parent1, parent2), 
                                      key=lambda z: graph.x[z])
            graph.connect(parent2, rev)
            try:
                branches[branches.index(parent2)] = nullid
            except ValueError:
                pass
        
        if parent1 != nullid:
            graph.connect(parent1, rev)
        
        xval = None
        try:
            xval = branches.index(parent1)
        except:
            s = revnos[parent1]
            try:
                xval = branches.index(nullid)
            except:
                xval = len(branches)
            for h in history[s:]:
                if xval < len(h) and h[xval] != nullid:
                    xval = max(len(branches), len(h))
            
        data = getdata(rev)
        caption = "%s (%s): %s" % (short(rev),
                                   ui.shortuser(data['user']),
                                   data['message'])
        graph.plot(rev, xval, revno, caption)
        
        if len(log.children(rev)) > 0:
            if xval >= len(branches):
                branches.append(rev)
            else:
                branches[xval] = rev
        
        history.append(branches[:])
    
    return graph

def print_graph(ui, repo, path='.', **opts):
    """Prints a graph of the history"""
    
    start = opts.get('start', None)
    finish = opts.get('end', None)
    if start != '': 
        start = [repo.lookup(start)]
    else:
        start = None
    if finish != '': 
        finish = [repo.lookup(finish)]
    else:
        finish = None
    
    graph = generate_graph(ui, repo, start, finish)
    filename = short(repo.heads()[0])
    graph.save('/tmp/%s.png' % filename)
    os.system('open /tmp/%s.png' % filename)


cmdtable = {
    "graph": (print_graph,
              [('s', 'start', '', 'The starting revision.'),
               ('e', 'end',   '', 'The ending revision.')],
              "hg print-parents [options]"),
}