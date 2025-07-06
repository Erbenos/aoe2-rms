#lang scribble/manual

@(require(except-in (for-label aoe2-rms) #%module-begin))
@(require(for-label racket/base))

@title{Age of Empires 2 Random Map Scripting}
@author["Erbenos (Miroslav Foltýn)"]

@defmodulelang[aoe2-rms]

This package implements a DSL for writing Age of Empires 2 Random Map Scripts.

@table-of-contents[]

@include-section["motivation.scrbl"]
@include-section["getting-started.scrbl"]
@include-section["syntax.scrbl"]
@include-section["recipes.scrbl"]
@include-section["acknowledgement.scrbl"]
