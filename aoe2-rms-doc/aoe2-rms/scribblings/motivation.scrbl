#lang scribble/manual

@(require(except-in (for-label aoe2-rms) #%module-begin))

@title{Motivation}

@section{State of Random Map Scripting}

Current iteration of the Age of Empires 2 Random Map Scripting Language is quite limited in terms of features that the developers may come to expect from other general purpose languages. @margin-note{You may want to refer to this @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0"]{document} for full overview of the current state.}

Some of the most bothersome features it lacks:

No support for user defined functions, little or no support for modules, lack of looping structures, limited conditional logic, limited math support, @etc

Over the years, the map makers have shown remarkable passion and determination in working around these limitations (and more) through:

@itemlist[
 @item{Various very specific generator scripts, such as Cliff Generator Script for Google Sheets (@hyperlink["https://discord.com/channels/488353991705493515/488353992930361346/1393134074754760705"]{Thread}, @hyperlink["https://docs.google.com/spreadsheets/d/1yEBjAwiA1LHY9J6NDwG5cN3H2B-I8a4R0sLzawixNVA/edit?gid=558461646#gid=558461646"]{Link}), Excel sheel based code generators (@hyperlink["https://www.youtube.com/watch?v=9mBJUJAgMFY"]{YouTube}) or more generic preprocessor scripts in GNU Octave. (@hyperlink["https://github.com/Alchemy-AOE-Community/CHEM-Random-Map-Scripts/tree/Workshop_TechChariot/Workshop_TechChariot/_Workshop/Shimmerpool"]{GitHub})

  @italic{These are painful workarounds for lack of expressiveness in the scripting language.}
 }
 @item{Website aggregating commonly used non-trivial behavior snippets. (@hyperlink["https://snippets.aoe2map.net/"]{Link})

  @italic{Workarounds for lack of mechanism for efficient code sharing.}
 }
 @item{Syntax highlighting support for various editors or even custom editors themselves. (@hyperlink["https://aok.heavengames.com/cgi-bin/forums/display.cgi?action=st&fn=28&tn=42485#:~:text=Syntax%20Highlighting%20and%20Text%20Editors"]{List})

  @italic{Cost of creating custom scripting language.}
 }
 ]

It is truly remarkable that such an old game has captivated so many resolute people.

@section{Closing The Gaps}

The @racket[aoe2-rms] package remedies these pains, albeit at the cost of a transpilation step, by allowing one to use full power of Racket for the map definition, which it then transpiles into the original scripting language.

Because the DSL is embedded into Racket, it will allow map makers to expoit all the work that has been put into the host language so far, including support for packaging, as well as various editor integration, which may perhaps not be as good as ones of more mainstream languages, they are certainly big improvement.

The flexbility of the Lisp-like language has also allowed the @racket[aoe2-rms] to be very synthetically close to its target language, hopefully making the transition easy, by making all existing resources still somewhat accurate and the existing knowledge people hold transferable.

@section{Development Philosophy}

Tenets of the @racket[aoe2-rms].

@itemlist[
 #:style 'compact
 @item{Enable more experienced map makers to build more complex maps.}
 @item{When possible and easy, keep the syntax similar enough to the target language.}
 @item{Do not try to prevent arbitrary target language quirks from occuring.
  (@hyperlink["https://aok.heavengames.com/cgi-bin/forums/display.cgi?action=ct&f=26,42304,,365"]{Parser Pitfalls})}
 @item{Enable code re-use.}
 @item{Make RMS syntax extensions possible, for example see @racket[%unless]}
 ]
