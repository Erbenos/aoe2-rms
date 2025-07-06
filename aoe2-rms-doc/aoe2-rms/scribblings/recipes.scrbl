#lang scribble/manual

@(require(except-in (for-label aoe2-rms) #%module-begin))

@title[#:tag "recipes"]{Recipes}

Slightly more advanced stuff for people without generic Racket language experience to show what is doable with @racket[aoe2-rms].

@include-section["user-defined-functions.scrbl"]
@include-section["modularizing-code.scrbl"]
