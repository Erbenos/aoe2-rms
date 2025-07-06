#lang scribble/manual

@(require(except-in (for-label aoe2-rms) #%module-begin))

@title[#:tag "getting-started"]{Getting Started}

This assumes you are familiar with the AoE2 RMS already, so it goes over how to start using this package instead. For resources regarding the AoE2 RMS, please see following @hyperlink["https://docs.google.com/document/u/0/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/mobilebasic"]{document}.

@section["Dependencies"]

Unfortunately, unlike with the actual .rms scripts, the process of using @racket[aoe2-rms] is a bit more involved. First, take care of setting up dependencies:

@itemlist[
 #:style 'ordered
 @item{@hyperlink["https://download.racket-lang.org/"]{Install Racket}}
 @item{@hyperlink["https://pkgs.racket-lang.org/package/aoe2-rms"]{Install aoe2-rms package} by running: @codeblock0{raco pkg install aoe2-rms} For more info see @secref["installing-packages" #:doc '(lib "pkg/scribblings/pkg.scrbl")].}
 ]

@section["Development Environment"]

You may use any editor you like. See @secref["other-editors" #:doc '(lib "scribblings/guide/guide.scrbl")] for list of editors that have Racket integration. I use Visual Studio Code with @hyperlink["https://marketplace.visualstudio.com/items?itemName=evzen-wybitul.magic-racket"]{Magic Racket extension}. Example of how that looks can be found at @hyperlink["https://www.youtube.com/watch?v=zPKP9Rm8igM"]{YouTube}.

@section["Transpiling Files"]

Create a @racket[example.rkt] file anywhere:

@racketmod[
 #:file "example.rkt"
 aoe2-rms

 (define (create-player-desert player)
   (create-land
    (terrain-type 'DESERT)
    (land-percent 3)
    (land-position 50 50)
    (assign-to-player (add1 player))))

 <PLAYER-SETUP>
 (direct-placement)

 <LAND-GENERATION>
 (for-each create-player-desert (range 2))
 ]

Then, you can convert it into random map script using Racket by running:

@codeblock{racket example.rkt}

Thanks to the @racketfont{#lang aoe2-rms} line at the top of file, Racket will recognize that this is meant to be random map script and spits out following text:

@code-inset{
 @codeblock0{
  <PLAYER_SETUP>
  direct_placement
  <LAND_GENERATION>
  create_land {
   terrain_type DESERT
   land_percent 3
   land_position 50 50
   assign_to_player 1
  }
  create_land {
   terrain_type DESERT
   land_percent 3
   land_position 50 50
   assign_to_player 2
  }
 }
}

You can also specify file to write the output to the @italic{"-d"} flag, like so:

@codeblock{racket example.rkt -d example.rms}

With above resulting in new "example.rms" file instead. In practice, one would setup some file-watcher script instead, re-running the @code{racket -d example.rkt} command when source file changes.

That is all you need to know to convert @racketfont{#lang aoe2-rms} files into Random Map Scripts. Head on to
@secref["syntax"] section for list of procedures and forms available in @racket[aoe2-rms] language.
