#!/usr/bin/env python

from mercurial import hg
from mercurial.commands import annotate, cmdutil

def extsetup():
    pass

def print_loc(ui, repo, *pats, **opts):
    """Prints out each users name and number of lines written."""

    get_username = lambda x: str(x[0].user())
    
    ctx = repo.changectx(opts['rev'])
    follow = opts.get('follow', False)
    counts = {}

    for src, abspath, rel, exact in cmdutil.walk(repo, pats, opts, 
                                                 node=ctx.node()):
        fctx = ctx.filectx(abspath)
        lines = fctx.annotate(follow=follow, linenumber=False)
        names = (get_username(meta) for meta,dummy in lines)
        for name in names:
            counts[name] = counts.get(name, 0) + 1
    
    total = sum(lines for lines in counts.itervalues())
    m = max(map(lambda x: len("%d" % x), counts.values() + [total]))
    for name,lines in counts.iteritems():   
        print "%*d: %s" % (m, lines, name)
    
    if opts['total']:
        print '%*d: Total' % (m, total)
    

cmdtable = {
    "loc": (print_loc,
           [('r', 'rev',      None, 'count using specific revision.'),
            ('%', 'percent',  None, 'print show percentage.'),
            ('f', 'follow',   None, 'Follow file copies and renames.'),
            ('t', 'total',    None, 'print total lines.'),
            ('u', 'users',    None, 'print breakdown by user. (default)')],
           "hg loc [options] FILE..."),
}