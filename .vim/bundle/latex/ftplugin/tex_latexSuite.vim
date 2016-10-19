" LaTeX filetype
"	  Language: LaTeX (ft=tex)
"	Maintainer: Srinath Avadhanula
"		 Email: srinath@fastmail.fm

set iskeyword+=:

if !exists('s:initLatexSuite')
	let s:initLatexSuite = 1
	exec 'so '.fnameescape(expand('<sfile>:p:h').'/latex-suite/main.vim')

	silent! do LatexSuite User LatexSuiteInitPost
endif

function! Tex_ForwardSearchLaTeX()
  let cmd = 'devince ' . fnamemodify(Tex_GetMainFileName(), ":p:r") .  '.pdf --page-label=' . a:page
  let output = system(cmd)
endfunction

silent! do LatexSuite User LatexSuiteFileType
