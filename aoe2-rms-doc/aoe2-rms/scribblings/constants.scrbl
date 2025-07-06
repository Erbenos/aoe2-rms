#lang scribble/manual

@(require(except-in (for-label aoe2-rms) #%module-begin))

@title[#:tag "constants"]{Constants}

Everything in the game is represented internally by a numeric identifier.  A constant is a label that can be used to refer the random map parser to the right item.  Many useful objects and terrains have predefined constants (see: @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.9iqqcke3biv"]{Constant Reference}). However, many objects and terrains also lack a predefined name.  In order to use them in your script, you must first assign a constant to the numeric id.

Note that, unless you need to refer to either @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.9iqqcke3biv"]{predefined constants}, predefined entities or use the defined constants in RMS @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.bqp5f3wcm40e"]{math operations}, there is little reason to use these instead of the @hyperlink["https://docs.racket-lang.org/guide/syntax-overview.html#(part._.Definitions)"]{Racket's variables}.


@defproc[(%const [const-label any/c] [const-value any/c]) void?]{
 Game versions: All

 Arguments:
 @itemlist[
 @item{const-label - text
   @itemlist[
 @item{AoC/UP - max length is 99 characters}
 @item{ANY characters are valid; convention is to use uppercase letters and underscores}
 ]}
 @item{const-value - number (see: @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.9iqqcke3biv"]{Constant Reference})
   @itemlist[@item{Maximum: 16777216 (2^24)}]
  }
 ]

 Assign a @seclink["constants"]{label} of your choice to a numeric ID, to be able to use the terrain/object associated with that ID.

 @itemlist[
 @item{This is required to use anything that is not predefined.}
 @item{Items can have multiple constants assigned to them.}
 @item{You cannot re-define a predefined name to a different ID.}
 @item{DE: You can use #const as a way to define a number. See @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.bqp5f3wcm40e"]{Math Operations}. This WILL work:
   @itemlist[@item{@racket[(%const "NUM" 10) (land-percent "NUM")]}]
  }
 @item{Pre-DE: You cannot use #const as a way to define a number. This will NOT work:
   @itemlist[@item{@racket[(%const "NUM" 10) (land-percent "NUM")]}]}
 @item{Constants are interpreted in context (ie. in body of @racket[create-object] the game will interpret it as an object, while in body of @racket[create-terrain] the game will interpret it as a terrain)
   @itemlist[
 @item{WARNING: Constants without a proper context are interpreted as syntax.  For more information, see this external article: @hyperlink["http://aok.heavengames.com/cgi-bin/forums/display.cgi?action=ct&f=26,42304,,365"]{Parser Pitfalls}
    }
 ]}
 ]

 Example: Define mossy road so you can use it later.
 @racketmod[
 aoe2-rms

 (%const 'ROAD_FUNGUS 32)
 ]

 Example:  Define and use variable constants depending on the season.

 @racketmod[
 aoe2-rms

 (%random [30 (%define 'WINTER)]
          [30 (%define 'AUTUMN)])

 (%cond ['WINTER
         (%const 'LAND_A 32)
         (%const 'BERRY_TYPE 52)]
        ['AUTUMN
         (%const 'LAND_A 5)
         (%const 'BERRY_TYPE 59)]
        [#f (%const 'LAND_A 3) (%const 'BERRY_TYPE 1059)])

 <LAND-GENERATION>
 (create-player-lands (terrain-type 'LAND_A))

 <OBJECTS-GENERATION>
 (create-object 'BERRY_TYPE
                (number-of-objects 5)
                (set-place-for-every-player)
                (set-gaia-object-only)
                (find-closest)
                (terrain-to-place-on 'LAND_A))
 ]
}
