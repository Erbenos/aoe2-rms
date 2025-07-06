#lang scribble/manual

@(require(except-in (for-label aoe2-rms) #%module-begin))

@title[#:tag "sections"]{Sections}

A random map script contains up to seven different sections.

This is the order in which the game will use sections to generate the map:

@racket[<PLAYER-SETUP>],
@racket[<LAND-GENERATION>],
@racket[<ELEVATION-GENERATION>],
@racket[<CLIFF-GENERATION>],
@racket[<TERRAIN-GENERATION>],
@racket[<CONNECTION-GENERATION>] and
@racket[<OBJECTS-GENERATION>].

The sections can be written in any order, but the game uses them in the order above.
The official scripts are not written in the "correct" order.
Not all sections are necessary.
If you don't want cliffs, don't include @racket[<CLIFF-GENERATION>].
You can have multiple sections of the same type.  They should function identically to a single section.

Each section has different commands that can be used in it.

@defidform[<PLAYER-SETUP>]{
 Default: @racket[random-placement]

 Attributes:
 @racket[random-placement], @racket[grouped-by-team], @racket[direct-placement], @racket[nomad-resources], @racket[force-nomad-treaty], @racket[behavior-version],
 @racket[override-map-size], @racket[set-gaia-civilization], @racket[ai-info-map-type], @racket[effect-amount], @racket[effect-percent], @racket[guard-state], @racket[terrain-state], @racket[weather-type] and @racket[water-definition].

 Required @seclink["sections"]{section}. Determines how players will be placed, and modifies global parameters.

 Example:
 @racketmod[
 aoe2-rms

 <PLAYER-SETUP>
 ]
}

@defidform[<LAND-GENERATION>]{
 Attributes:
 @racket[base-terrain], @racket[base-layer] and @racket[enable-waves].

 Blocks:
 @racket[create-player-lands] and @racket[create-land].

 @seclink["sections"]{Section} to place large areas of terrain, including the player starting areas.  Required if you want to place players.  Land origins (square bases) are placed in order. After all origins are placed, all lands grow simultaneously from their origins outwards in all directions to fill the amount of space specified for each land, or until they run into a border or another land. @bold{Land growth happens all at once!}

 Example:
 @racketmod[
 aoe2-rms

 <LAND-GENERATION>
 ]
}

@defidform[<ELEVATION-GENERATION>]{
 Blocks:
 @racket[create-elevation].

 Optional @seclink["sections"]{section} used to place hills on your map.

 @itemlist[
 @item{Elevation avoids the origins of player lands by about 9 tiles.}
 @item{If @racket[base-elevation] was specified for any lands, you must include this section, even if it is empty.}
 @item{Elevation provides a combat bonus to higher units, and a debuff to lower units.}
 @item{Hill positions are noticeably biased towards being placed in the south. In DE, you should always use @racket[enable-balanced-elevation] to reduce this bias.}
 ]

 Example:
 @racketmod[
 aoe2-rms

 <ELEVATION-GENERATION>
 ]
}

@defidform[<CLIFF-GENERATION>]{
 Attributes:
 @racket[cliff-type], @racket[min-number-of-cliffs], @racket[max-number-of-cliffs], @racket[min-length-of-cliff], @racket[max-length-of-cliff], @racket[cliff-curliness], @racket[min-distance-cliffs] and @racket[min-terrain-distance].

 Optional @seclink["sections"]{section} to include rocky impassible cliffs.

 @itemlist[
 @item{Simply typing the section header will generate default cliffs, so do not include it if you do not want cliffs!}
 @item{Cliffs avoid the origins of all lands by 22 tiles, and will not be placed on water terrains.  They also avoid any slopes.}
 @item{Cliffs create a terrain under themselves.  This is terrain 16, and looks like the normal grass.  This terrain turns into terrain 0 (GRASS) prior to @racket[object-generation] but can be replaced during @racket[<TERRAIN-GENERATION>]}
 @item{Cliffs provide a combat bonus to units shooting from the top of a cliff.}
 ]

 Example:
 @racketmod[
 aoe2-rms

 <CLIFF-GENERATION>
 ]
}

@defidform[<TERRAIN-GENERATION>]{
 Attributes:
 @racket[color-correction].

 Blocks:
 @racket[create-terrain].

 @seclink["sections"]{Section} to specify terrain replacements.

 Often used to place clumps of forest and to make the map look nice by mixing terrains for visual diversity.  Terrain generation occurs after lands, elevation and cliffs, but before connections.  Terrains are generated sequentially in the order they appear in the script.  Terrain positions cannot be directly specified.

 Example:
 @racketmod[
 aoe2-rms

 <TERRAIN-GENERATION>
 ]
}

@defidform[<CONNECTION-GENERATION>]{
 Attributes:
 @racket[accumulate-connections].

 Blocks:
 @racket[create-connect-all-players-land], @racket[create-connect-teams-lands], @racket[create-connect-all-lands], @racket[create-connect-same-land-zones], @racket[create-connect-land-zones], and @racket[create-connect-to-nonplayer-land].

 Optional @seclink["sections"]{section} to replace terrains with other terrains, specifically along a path between the origins of lands.  Can be used to create roads between players, shallows across rivers, and to ensure that forests do not completely separate players.

 @itemlist[
 @item{You can only specify whole systems of connections, not individual connections.}
 @item{Connections are processed in order.}
 @item{If the connection between two locations is not possible, that connection will not be produced at all.}
 ]

 Example:
 @racketmod[
 aoe2-rms

 <CONNECTION-GENERATION>
 ]
}

@defidform[<OBJECTS-GENERATION>]{
 Attributes:
 @racket[create-actor-area].

 Blocks:
 @racket[create-object], @racket[create-object-group].

 Place buildings, units, resources, animals, straggler trees, decoration, etc.  Objects are placed in order.  Normally, only 1 object can be placed per tile.  If an object cannot find a valid position, it will not generate at all.  So you should place the most important objects first.  There are a few unusual cases:

 @itemlist[
 @item{Creating the object VILLAGER without specifying the amount will give each civilization their correct number of starting villagers.}
 @item{In DE this has changed and everyone gets 3 villagers to start, with the extra ones being spawned by the town center (to prevent Chinese from being too strong on nomad starts).}
 @item{The object SCOUT will give an eagle to mesoamerican civilizations and a scout to all other civilizations.
   Walls have some special behavior (see: @hyperlink["https://docs.google.com/document/u/0/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/mobilebasic#h.q7o6xdvi0noo"]{Walls})}
 ]

 Example:
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 ]
}
