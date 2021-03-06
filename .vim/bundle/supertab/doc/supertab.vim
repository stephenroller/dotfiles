Authors:
  Original: Gergely Kontra <kgergely@mcl.hu>
  Current:  Eric Van Dewoestine <ervandew@gmail.com> (as of version 0.4)

Contributors:
  Christophe-Marie Duquesne <chm.duquesne@gmail.com> (documentation)

Please direct all correspondence to Eric.

This plugin is licensed under the terms of the BSD License.  Please see
supertab.vim for the license in its entirety.

==============================================================================
Supertab                                    *supertab*

1. Introduction                         |supertab-intro|
2. Supertab Usage                       |supertab-usage|
3. Supertab Options                     |supertab-options|
    Default completion type             |supertab-defaultcompletion|
    Secondary default completion type   |supertab-contextdefault|
    Completion contexts                 |supertab-completioncontexts|
        Context text                    |supertab-contexttext|
        Context Discover                |supertab-contextdiscover|
        Example                         |supertab-contextexample|
    Completion Duration                 |supertab-duration|
    Midword completion                  |supertab-midword|
    Changing default mapping            |supertab-forwardbackward|
    Inserting true tabs                 |supertab-mappingtabliteral|
    Preselecting the first entry        |supertab-longesthighlight|

==============================================================================
1. Introduction                             *supertab-intro*

Supertab is a plugin which allows you to perform all your insert completion
(|ins-completion|) using the tab key.

Supertab requires Vim version 7.0 or above.

==============================================================================
2. Supertab usage                           *supertab-usage*

Using Supertab is as easy as hitting <Tab> or <S-Tab> (shift+tab) while in
insert mode, with at least one non whitespace character before the cursor, to
start the completion and then <Tab> or <S-Tab> again to cycle forwards or
backwards through the available completions.

Example ('|' denotes the cursor location):

bar
baz
b|<Tab>    Hitting <Tab> here will start the completion, allowing you to
           then cycle through the suggested words ('bar' and 'baz').

==============================================================================
3. Supertab Options                         *supertab-options*

Supertab is configured via several global variables that you can set in your
|vimrc| file according to your needs. Below is a comprehensive list of
the variables available.

g:SuperTabDefaultCompletionType             |supertab-defaultcompletion|
  The default completion type to use. If you program in languages that support
  omni or user completions, it is highly recommended setting this to
  'context'.

  For help about built in completion types in vim, see |i_CTRL-X_index|.

g:SuperTabContextDefaultCompletionType      |supertab-contextdefault|
  The default completion type to use when 'context' is the global default, but
  context completion has determined that neither omni, user, or file
  completion should be used in the current context.

g:SuperTabCompletionContexts                |supertab-completioncontexts|
  Used to configure a list of function names which are used when the global
  default type is 'context'. These functions will be consulted in order to
  determine which completion type to use. Advanced users can plug in their own
  functions here to customize their 'context' completion.

g:SuperTabRetainCompletionDuration          |supertab-duration|
  This setting determines how long a non-default completion type should be
  retained as the temporary default. By default supertab will retain the
  alternate completion type until you leave insert mode.

g:SuperTabMidWordCompletion                 |supertab-midword|
  This can be used to turn off completion if you are in the middle of a word
  (word characters immediately preceding and following the cursor).

g:SuperTabMappingForward                    |supertab-forwardbackward|
g:SuperTabMappingBackward                   |supertab-forwardbackward|
  If using the tab key for completion isn't for you, then you can use these to
  set an alternate key to be used for your insert completion needs.

g:SuperTabMappingTabLiteral                 |supertab-mappingtabliteral|
  For those rare cases where supertab would normal want to start insert
  completion, but you just want to insert a tab, this setting is used to
  define the key combination to use to do just that.  By default Ctrl-Tab is
  used.

g:SuperTabLongestHighlight                  |supertab-longesthighlight|
  When enabled and you have the completion popup enable and 'longest' in your
  completeopt, supertab will auto highlight the first selection in the popup.


Default Completion Type             *supertab-defaultcompletion*
                                    *g:SuperTabDefaultCompletionType*

g:SuperTabDefaultCompletionType (default value: "<c-p>")

Used to set the default completion type. There is no need to escape this
value as that will be done for you when the type is set.

  Example: setting the default completion to 'user' completion:

    let g:SuperTabDefaultCompletionType = "<c-x><c-u>"

Note: a special value of 'context' is supported which will result in
super tab attempting to use the text preceding the cursor to decide which
type of completion to attempt.  Currently super tab can recognize method
calls or attribute references via '.', '::' or '->', and file path
references containing '/'.

    let g:SuperTabDefaultCompletionType = "context"

    /usr/l<tab>     # will use filename completion
    myvar.t<tab>    # will use user completion if completefunc set,
                    # or omni completion if omnifunc set.
    myvar-><tab>    # same as above

When using context completion, super tab will fall back to a secondary default
completion type set by |g:SuperTabContextDefaultCompletionType|.

Note: once the buffer has been initialized, changing the value of this setting
will not change the default complete type used.  If you want to change the
default completion type for the current buffer after it has been set, perhaps
in an ftplugin, you'll need to call SuperTabSetDefaultCompletionType like so,
supplying the completion type you wish to switch to:

    call SuperTabSetDefaultCompletionType("<c-x><c-u>")


Secondary default completion type   *supertab-contextdefault*
                                    *g:SuperTabContextDefaultCompletionType*

g:SuperTabContextDefaultCompletionType (default value: "<c-p>")

Sets the default completion type used when g:SuperTabDefaultCompletionType is
set to 'context' and no completion type is returned by any of the configured
contexts.


Completion contexts                 *supertab-completioncontexts*
                                    *g:SuperTabCompletionContexts*

g:SuperTabCompletionContexts (default value: ['s:ContextText'])

Sets the list of contexts used for context completion.  This value should
be a list of function names which provide the context implementation.

When supertab starts the default completion, each of these contexts will be
consulted, in the order they were supplied, to determine the completion type
to use.  If a context returns a completion type, that type will be used,
otherwise the next context in the list will be consulted.  If after executing
all the context functions, no completion type has been determined, then the
value of g:SuperTabContextDefaultCompletionType will be used.

Built in completion contexts:

  s:ContextText                     *supertab-contexttext*

  The text context will examine the text near the cursor to decide which type
  of completion to attempt.  Currently the text context can recognize method
  calls or attribute references via '.', '::' or '->', and file path
  references containing '/'.

      /usr/l<tab>  # will use filename completion
      myvar.t<tab> # will use user completion if completefunc set, or
                   # omni completion if omnifunc set.
      myvar-><tab> # same as above

  Supported configuration attributes:

    g:SuperTabContextTextFileTypeExclusions
    List of file types for which the text context will be skipped.

    g:SuperTabContextTextOmniPrecedence
    List of omni completion option names in the order of precedence that they
    should be used if available. By default, user completion will be given
    precedence over omni completion, but you can use this variable to give
    omni completion higher precedence by placing it first in the list.

  s:ContextDiscover                 *supertab-contextdiscover*

  This context will use the 'g:SuperTabContextDiscoverDiscovery' variable to
  determine the completion type to use.  It will evaluate each value, in the
  order they were defined, until a variable evaluates to a non-zero or
  non-empty value, then the associated completion type is used.

  Supported configuration properties:

    g:SuperTabContextDiscoverDiscovery
    List of variable:completionType mappings.

  Example context configuration:    *supertab-contextexample*

    let g:SuperTabCompletionContexts = ['s:ContextText', 's:ContextDiscover']
    let g:SuperTabContextTextOmniPrecedence = ['&omnifunc', '&completefunc']
    let g:SuperTabContextDiscoverDiscovery =
        \ ["&completefunc:<c-x><c-u>", "&omnifunc:<c-x><c-o>"]

  In addition to the default completion contexts, you can plug in your own
  implementation by creating a globally accessible function that returns
  the completion type to use (eg. "\<c-x>\<c-u>").

    function MyTagContext()
      if filereadable(expand('%:p:h') . '/tags')
        return "\<c-x>\<c-]>"
      endif
      " no return will result in the evaluation of the next
      " configured context
    endfunction
    let g:SuperTabCompletionContexts =
        \ ['MyTagContext', 's:ContextText', 's:ContextDiscover']

  Note: supertab also supports the b:SuperTabCompletionContexts variable
  allowing you to set the list of contexts separately for the current buffer,
  like from an ftplugin for example.


Completion Duration                 *supertab-duration*
                                    *g:SuperTabRetainCompletionDuration*

g:SuperTabRetainCompletionDuration (default value: 'insert')

Determines if, and for how long, the current completion type is retained.
The possible values include:
'completion' - The current completion type is only retained for the
               current completion.  Once you have chosen a completion
               result or exited the completion mode, the default
               completion type is restored.
'insert'     - The current completion type is saved until you exit insert
               mode (via ESC).  Once you exit insert mode the default
               completion type is restored. (supertab default)
'session'    - The current completion type is saved for the duration of
               your vim session or until you enter a different completion
               mode.


Midword completion                  *supertab-midword*
                                    *g:SuperTabMidWordCompletion*

g:SuperTabMidWordCompletion (default value: 1)

Sets whether or not mid word completion is enabled. When enabled, <tab> will
kick off completion when ever a non whitespace character is to the left of the
cursor.  When disabled, completion will only occur if the char to the left is
non whitespace char and the char to the right is not a keyword character (you
are at the end of the word).


Changing the default mapping        *supertab-forwardbackward*
                                    *g:SuperTabMappingForward*
                                    *g:SuperTabMappingBackward*

g:SuperTabMappingForward  (default value: '<tab>')
g:SuperTabMappingBackward (default value: '<s-tab>')

These two variables allow you to set the keys used to kick off the current
completion.  By default this is <tab> and <s-tab>.  To change to something
like <c-space> and <s-c-space>, you can add the following to your |vimrc|.

        let g:SuperTabMappingForward = '<c-space>'
        let g:SuperTabMappingBackward = '<s-c-space>'

Note: if the above does not have the desired effect (which may happen in
console version of vim), you can try the following mappings.  Although the
backwards mapping still doesn't seem to work in the console for me, your
milage may vary.

        let g:SuperTabMappingForward = '<nul>'
        let g:SuperTabMappingBackward = '<s-nul>'


Inserting true tabs                 *supertab-mappingtabliteral*
                                    *g:SuperTabMappingTabLiteral*

g:SuperTabMappingTabLiteral (default value: '<c-tab>')

Sets the key mapping used to insert a literal tab where supertab would
otherwise attempt to kick off insert completion. The default is '<c-tab>'
(ctrl-tab) which unfortunately might not work at the console. So if you are
using a console vim and want this functionality, you may have to change it to
something that is supported.  Alternatively, you can escape the <tab> with
<c-v> (see |i_CTRL-V| for more infos).


Preselecting the first entry        *supertab-longesthighlight*
                                    *g:SuperTabLongestHighlight*

g:SuperTabLongestHighlight (default value: 0)

Sets whether or not to pre-highlight the first match when completeopt has the
popup menu enabled and the 'longest' option as well. When enabled, <tab> will
kick off completion and pre-select the first entry in the popup menu, allowing
you to simply hit <enter> to use it.

vim:tw=78:ts=8:ft=help:norl:
