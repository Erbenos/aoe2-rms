#lang scribble/manual

@(require(except-in (for-label aoe2-rms) #%module-begin))

@title[#:tag "comments"]{Comments}

A comment is a piece of text that is ignored by the AOE's parser, but provides helpful information to someone looking at the code, such as yourself. Note that unless you want to preserve the comments in the generated script file,
its generally advisable to use Racket's @hyperlink["https://docs.racket-lang.org/reference/reader.html#%28part._parse-comment%29"]{comments} instead.

@defproc[(%comment [text any/c]) void?]{
 Creates a @seclink["comments"]{comment} that will be embedded into the generated script file.

 @itemlist[
 @item{Comments can be nested.  If you have a comment within a comment, the "sub comment" will not prematurely terminate the main comment, even if syntax highlighters indicate otherwise.}
 @item{BUG (pre-DE): Comments within dead branches (see: @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.vs551a7tyxet"]{Conditionals} and @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.87mv66lnefdm"]{Random Code}) are NOT ignored.  For more information, see this external article: @hyperlink["http://aok.heavengames.com/cgi-bin/forums/display.cgi?action=ct&f=26,42304,,365"]{Parser Pitfalls}}
 ]

 Example:
 @#reader scribble/comment-reader
 (racketmod
 aoe2-rms

 (%comment "This is a comment")
 ; This is also a comment, but it won't saved into the generated file
 )
}
