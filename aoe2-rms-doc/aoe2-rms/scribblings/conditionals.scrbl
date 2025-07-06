#lang scribble/manual

@(require(except-in (for-label aoe2-rms) #%module-begin))

@title[#:tag "conditionals"]{Conditionals}

Conditionals are pieces of code that will be executed based on whether a specified condition is fulfilled.
The game has predefined most lobby settings as conditions. See full set of @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.vs551a7tyxetů"]{conditions available}.

You can detect other game versions, as well as total conversion mods by exploiting differences in the @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.9iqqcke3biv"]{predefined constants} within random_map.def of the respective game versions.

@defform[(%cond cond-clause ...)
         #:grammar
         [(cond-clause (code:line [cond-label then-body ...])
                       [#f then-body ...])]]{
 Game versions: All

 Arguments:
 @itemlist[
 @item{cond-label - either a predefined condition or a @seclink["conditionals"]{custom condition} created using @racket[%define].}
 @item{then-body - anything that will become body thats executed when given condition is valid.}
 ]

 Execute a piece of code if a condition is fulfilled, with the option of specifying alternative conditions and pieces of code to execute.
 @itemlist[
 @item{if the condition is true will stop checking further conditions.}
 @item{@bold{"#f" represents else condition, when specified, it must be the last cond-clause.}}
 @item{Can be used within @seclink["blocks"]{blocks} or around arbitrary code segments.}
 @item{Conditionals can be nested.}
 @item{BUG (AoC/HD): Comments in dead branches are not ignored.  Do not include any conditional syntax in such comments.  Be especially careful with "if" since it is easy to inadvertently type it in a comment!  For more information, see this external article: @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#:~:text=http%3A//aok.heavengames.com/cgi%2Dbin/forums/display.cgi%3Faction%3Dct%26f%3D26%2C42304%2C%2C365"]{Parser Pitfalls}}
 ]

 Note that unlike @racket[cond], all branches are always executed during code generation.

 Example: Manually scale relic count to map size.
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (create-object 'RELIC
                (min-distance-to-players 25)
                (%cond ['TINY_MAP
                        (number-of-objects 5)
                        (temp-min-distance-group-placement 35)]
                       ['SMALL_MAP
                        (number-of-objects 5)
                        (temp-min-distance-group-placement 38)]
                       ['MEDIUM_MAP
                        (number-of-objects 5)
                        (temp-min-distance-group-placement 38)]
                       ['LARGE_MAP
                        (number-of-objects 7)
                        (temp-min-distance-group-placement 48)]
                       ['HUGE_MAP
                        (number-of-objects 8)
                        (temp-min-distance-group-placement 52)]
                       [#f (number-of-objects 999) (temp-min-distance-group-placement 52)]))
 ]

 Example: Replace the scout with a king when playing regicide.
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (%cond ['REGICIDE (%const 'HERO 'KING)]
        [#f (%const 'HERO 'SCOUT)])

 (create-object 'HERO
                (set-place-for-every-player)
                (min-distance-to-players 7)
                (max-distance-to-players 9))
 ]

 Example: Set up a NOT conditional - place a cow when "infinite resources" is not true.
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (%cond ['INFINITE_RESOURCES]
        [#f (create-object 'DLC_COW
                           (set-place-for-every-player)
                           (find-closest))])
 ]

 Example: Check for various game versions.
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (%cond ['DE_AVAILABLE]
        ['DLC_TIGER (%cond ['UP_EXTENSION (%define 'WOLOLOKINGDOMS)]
                           [#f (%define 'HD_DLC)])]
        ['DLC_COW (%define 'HD_BASE)]
        ['UP_EXTENSION]
        ['UP_AVAILABLE]
        [#f (%define 'CONQUERORS_CD)])
 ]
}

@defform[(%unless cond-label then-body ...)]{
 Same as:


 @(racketblock
   (%cond [cond-label] [#f then-body ...]))

 Example: Set up a NOT conditional - place a cow when "infinite resources" is not true.
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (%unless 'INFINITE_RESOURCES
          (create-object 'DLC_COW
                         (set-place-for-every-player)
                         (find-closest)))
 ]
}

@defproc[(%define [cond-label any/c]) void?]{
 Game versions: All

 Arguments:

 cond-label - text

 @itemlist[
 @item{AoC/UP - max length is 99 characters}
 @item{ANY characters are valid; convention is to use uppercase letters and underscores}
 ]

 Define your own condition labels, to refer to at a later point. Do not use any predefined constants.

 Example: Set up seasonal variations for the base terrain.
 @racketmod[
 aoe2-rms

 (%random [20 (%define 'WINTER)]
          [20 (%define 'AUTUMN)])

 <LAND-GENERATION>
 (%cond ['WINTER (base-terrain 'SNOW)]
        ['AUTUMN (base-terrain 'LEAVES)]
        [#f (base-terrain 'DIRT)])
 ]
}
