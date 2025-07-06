#lang scribble/manual

@(require(except-in (for-label aoe2-rms) #%module-begin))

@title[#:tag "raw"]{Raw}

@defproc[(%raw [contents any/c]) void?]{
 Embeds contents as is into the generated map script.

 Example: Prints "Hello There" into the generated script exactly as is.
 @racketmod[
 aoe2-rms

 (%raw "Hello There")
 ]
}

