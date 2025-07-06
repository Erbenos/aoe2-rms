#lang scribble/manual

@(require(except-in (for-label aoe2-rms) #%module-begin))

@title[#:tag "syntax" #:style 'toc]{Syntax}

This section is a modified version of existing @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0"]{random map scripting resource written by Zetnus} with updated syntax according to the @racketfont{#lang aoe2-rms}, including new syntax forms and examples. This documentation also enables nice in-editor integration.

In many places above mentioned document is linked as reference for listings of predefined constants, condition labels and additional information thats outside of this package's scope, for now.

You may wish to go through the @secref["to-scheme" #:doc '(lib "scribblings/guide/guide.scrbl")], to grasp the Racket language syntax and overall basics, especially if you have no Lisp experience and want to start building more complex stuff, the examples should however be understandable even just with some preliminary RMS experience.

@local-table-of-contents[]

@include-section["sections.scrbl"]
@include-section["attributes.scrbl"]
@include-section["blocks.scrbl"]
@include-section["comments.scrbl"]
@include-section["including-files.scrbl"]
@include-section["random-code.scrbl"]
@include-section["conditionals.scrbl"]
@include-section["constants.scrbl"]
@include-section["raw.scrbl"]
