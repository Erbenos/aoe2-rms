#lang scribble/manual

@(require(except-in (for-label aoe2-rms) #%module-begin))

@title[#:tag "blocks"]{Blocks}

For any block form, attributes created within the body forms will become attributes of given block.
Execution of the bodies is deferred to after the expansion of the block forms, if you want to create custom block constructors
via functions, wrap the bodies in callbacks.

@defform[(create-player-lands body ...)
         #:contracts ([body any/c])]{
 Section:
 @racket[<LAND-GENERATION>].

 Attributes:
 @racket[terrain-type], @racket[land-percent], @racket[number-of-tiles], @racket[base-size], @racket[set-circular-base], @racket[generate-mode], @racket[circle-radius],
 @racket[left-border], @racket[right-border], @racket[top-border], @racket[bottom-border], @racket[border-fuzziness], @racket[clumping-factor], @racket[land-conformity], @racket[base-elevation], @racket[zone], @racket[set-zone-by-team], @racket[set-zone-randomly], @racket[other-zone-avoidance-distance] and @racket[land-id].

 Game versions: All

 Creates a land for every player.

 @itemlist[
 @item{Usually this command is used only once, but it can be repeated to, for example, give every player two starting towns.}
 @item{Not required — you can use @racket[create-land] with the @racket[assign-to-player] or @racket[assign-to] attributes to give lands directly to individual players instead (or in addition to creating player lands).}
 @item{If you do not give players any lands at all, you cannot give them any starting units or resources. They will start at an entirely random location with only a town center, villagers, and scout. This is NOT recommended.}
 @item{DE: Using @racket[direct-placement] with create-player-lands disables the circular land positioning, so this is usually not desirable.}
 ]

 Example: Create player lands made of dirt.
 @racketmod[
 aoe2-rms

 <LAND-GENERATION>
 (create-player-lands
  (terrain-type 'DIRT)
  (land-percent 20))
 ]
}

@defform[(create-land body ...) #:contracts ([body any/c])]{
 Section:
 @racket[<LAND-GENERATION>].

 Attributes:
 @racket[terrain-type], @racket[land-percent], @racket[number-of-tiles], @racket[base-size], @racket[set-circular-base], @racket[land-position], @racket[left-border], @racket[right-border], @racket[top-border], @racket[bottom-border], @racket[border-fuzziness], @racket[clumping-factor], @racket[land-conformity], @racket[base-elevation], @racket[assign-to-player], @racket[assign-to], @racket[zone], @racket[set-zone-randomly], @racket[other-zone-avoidance-distance], @racket[min-placement-distance] and @racket[land-id].

 Game versions: All

 Create a single non-player (neutral) land.

 Can be assigned to a player with @racket[assign-to-player] or @racket[assign-to].

 Example: Create lake in the center.
 @racketmod[
 aoe2-rms

 <LAND-GENERATION>
 (create-land
  (terrain-type 'WATER)
  (land-percent 10)
  (land-position 50 50))
 ]
}

@defform[(create-elevation max-height body ...) #:contracts ([max-height any/c] [body any/c])]{
 Section: @racket[<ELEVATION-GENERATION>].

 Attributes:
 @racket[base-terrain], @racket[base-layer], @racket[number-of-tiles], @racket[number-of-clumps], @racket[set-scale-by-size], @racket[set-scale-by-groups], @racket[spacing] and @racket[enable-balanced-elevation].

 Game versions: All

 @itemlist[
 @item{max-height — number (1-16) (default: 0 — not elevated)}
 ]

 Create one or more hills of random height, up to the given height.

 @itemlist[
 @item{When creating a single hill, this hill will always attempt to reach the height specified.}
 @item{Hills with a small number of base tiles are not able to reach as high.}
 @item{HD/DE: If terrain has already been elevated with a land's @racket[base-elevation], new hills will be relative to that height.}
 @item{UP: Hills always use an absolute height, even if a terrain has already been elevated with a land's @racket[base-elevation].}
 @item{Pre-DE: maximum is 7.}
 @item{Higher elevations towards 16 may cause unwanted behavior, such as TC projectiles firing in a different way.}
 ]

 Example: Create one hill on grassy terrain.
 @racketmod[
 aoe2-rms

 <ELEVATION-GENERATION>
 (create-elevation 7
                   (base-terrain 'GRASS)
                   (number-of-tiles 600))
 ]
}

@defform[(create-terrain type body ...) #:contracts ([type any/c] [body any/c])]{
 Section: @racket[<TERRAIN-GENERATION>].

 Attributes:
 @racket[base-terrain], @racket[base-layer], @racket[beach-terrain], @racket[terrain-mask], @racket[spacing-to-other-terrain-types], @racket[spacing-to-specific-terrain], @racket[set-flat-terrain-only], @racket[land-percent], @racket[number-of-tiles], @racket[number-of-clumps], @racket[clumping-factor], @racket[set-scale-by-size], @racket[set-scale-by-groups], @racket[set-avoid-player-start-areas] and @racket[height-limits].

 Game versions: All

 @itemlist[
 @item{type - terrain constant (see: @hyperlink["https://docs.google.com/document/u/0/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/mobilebasic#h.3bdjnf7tryyk"]{Terrains}) (default: GRASS)}
 ]

 Create a clump of terrain.  The exact behavior is dependent on the attributes specified.

 Example: Create a large clump of forest terrain on grass terrain
 @racketmod[
 aoe2-rms

 <TERRAIN-GENERATION>
 (create-terrain 'FOREST
                 (base-terrain 'GRASS)
                 (land-percent 10))
 ]
}

@defform[(create-connect-all-players-land body ...) #:contracts ([body any/c])]{
 Section: @racket[<CONNECTION-GENERATION>].

 Attributes:
 @racket[default-terrain-replacement], @racket[replace-terrain], @racket[terrain-cost] and @racket[terrain-size].

 Game versions: All

 Connections will be generated between the origins of all player lands, and all lands assigned to players.

 Connections may pass through neutral lands if the cost is favorable.

 Example: Connect all players with dirt terrain
 @racketmod[
 aoe2-rms

 <LAND-GENERATION>
 (create-player-lands
  (terrain-type 'DESERT)
  (number-of-tiles 100))

 <CONNECTION-GENERATION>
 (create-connect-all-players-land
  (default-terrain-replacement 'DIRT))
 ]
}

@defform[(create-connect-teams-lands body ...) #:contracts ([body any/c])]{
 Section: @racket[<CONNECTION-GENERATION>].

 Attributes:
 @racket[default-terrain-replacement], @racket[replace-terrain], @racket[terrain-cost] and @racket[terrain-size].

 Game versions: All

 Connections will be generated between the origins of player lands belonging to members of the same team.

 Connections may pass through neutral or enemy lands if the cost is favorable.
 By default, players are on their own team in the scenario editor, so keep this in mind when testing in the scenario editor.

 You can use the diplomacy tab to simulate team setups.

 Example: Connect team members with a road
 @racketmod[
 aoe2-rms

 <LAND-GENERATION>
 (create-player-lands
  (terrain-type 'DESERT)
  (number-of-tiles 100))

 <CONNECTION-GENERATION>
 (create-connect-teams-lands
  (replace-terrain 'DESERT 'ROAD)
  (replace-terrain 'GRASS 'ROAD))
 ]
}

@defform[(create-connect-all-lands body ...) #:contracts ([body any/c])]{
 Section: @racket[<CONNECTION-GENERATION>].

 Attributes:
 @racket[default-terrain-replacement], @racket[replace-terrain], @racket[terrain-cost] and @racket[terrain-size].

 Game versions: All

 Connections will be generated between the origins of all lands.

 Example: Interconnect all player islands and neutral islands.
 @racketmod[
 aoe2-rms

 <LAND-GENERATION>
 (base-terrain 'WATER)
 (create-player-lands
  (terrain-type 'DESERT)
  (number-of-tiles 100))
 (create-land
  (terrain-type 'FOREST)
  (number-of-tiles 100)
  (land-position 99 1))
 (create-land
  (terrain-type 'PINE_FOREST)
  (number-of-tiles 100)
  (land-position 50 50))

 <CONNECTION-GENERATION>
 (create-connect-all-lands (replace-terrain 'WATER 'SHALLOW))
 ]
}

@defform[(create-connect-same-land-zones body ...) #:contracts ([body any/c])]{
 Section: @racket[<CONNECTION-GENERATION>].

 Attributes:
 @racket[default-terrain-replacement], @racket[replace-terrain], @racket[terrain-cost] and @racket[terrain-size].

 Game versions: DE only

 Connect all player lands to all neutral lands, but do not directly generate connections between individual players.

 BUG: @racket[create-connect-to-nonplayer-land] blocks all future connection generation.
 BUG: It also blocks all team connection generation (except those involving player 1), when used after @racket[create-connect-teams-lands].
}

@defform[(create-connect-land-zones zone1 zone2 body ...) #:contracts ([body any/c])]{
 Section: @racket[<CONNECTION-GENERATION>].

 Attributes:
 @racket[default-terrain-replacement], @racket[replace-terrain], @racket[terrain-cost] and @racket[terrain-size].

 Game versions: DE only

 Arguments:

 zone1 - numeric zone ID
 zone2 - numeric zone ID

 Generate connections between all lands belonging to the zones listed.

 By default lands from @racket[create-player-lands] are each in their own unique zone (PlayerNumber - 10), while lands created with @racket[create-land] all share the same zone (-10).

 Example: Connect a lake, forest and desert to each other.
 @racketmod[
 aoe2-rms

 <LAND-GENERATION>
 (create-land
  (terrain-type 'FOREST)
  (land-percent 5)
  (zone 1))
 (create-land
  (terrain-type 'DESERT)
  (land-percent 5)
  (zone 1))
 (create-land
  (terrain-type 'WATER)
  (land-percent 5)
  (zone 50))

 <CONNECTION-GENERATION>
 (create-connect-land-zones 1 50
                            (default-terrain-replacement 'ICE))
 ]

 Example: Connect player 2 and player 4
 @racketmod[
 aoe2-rms

 <LAND-GENERATION>
 (create-player-lands
  (terrain-type 'DESERT)
  (land-percent 5))

 <CONNECTION-GENERATION>
 (create-connect-land-zones -6 -8
                            (default-terrain-replacement 'ROAD))
 ]
}

@defform[(create-connect-to-nonplayer-land body ...) #:contracts ([body any/c])]{
 Section: @racket[<CONNECTION-GENERATION>].

 Attributes:
 @racket[default-terrain-replacement], @racket[replace-terrain], @racket[terrain-cost] and @racket[terrain-size].

 Game versions: DE only

 Connect all player lands to all neutral lands, but do not directly generate connections between individual players.

 BUG: @racket[create-connect-to-nonplayer-land] blocks all future connection generation.
 BUG: It also blocks all team connection generation (except those involving player 1), when used after @racket[create-connect-teams-lands].

 Example: Connect players to a central desert, but not directly to each other
 @racketmod[
 aoe2-rms

 <LAND-GENERATION>
 (create-player-lands
  (terrain-type 'DIRT2)
  (number-of-tiles 100))

 (create-land
  (terrain-type 'DESERT)
  (number-of-tiles 500)
  (land-position 50 50))

 <CONNECTION-GENERATION>
 (create-connect-to-nonplayer-land
  (replace-terrain 'GRASS 'ROAD2))
 ]
}

@defform[(create-object type body ...) #:contracts ([type any/c] [body any/c])]{
 Section: @racket[<OBJECTS-GENERATION>].

 Attributes:
 @racket[number-of-objects], @racket[number-of-groups], @racket[group-variance], @racket[group-placement-radius], @racket[set-tight-grouping], @racket[set-loose-grouping], @racket[min-connected-tiles], @racket[resource-delta], @racket[second-object], @racket[set-scaling-to-map-size], @racket[set-scaling-to-player-number], @racket[set-place-for-every-player], @racket[place-on-specific-land-id], @racket[avoid-other-land-zones], @racket[generate-for-first-land-only], @racket[set-gaia-object-only], @racket[set-gaia-unconvertible], @racket[set-building-capturable], @racket[make-indestructible], @racket[min-distance-to-players], @racket[max-distance-to-players], @racket[set-circular-placement], @racket[terrain-to-place-on], @racket[layer-to-place-on], @racket[ignore-terrain-restrictions], @racket[max-distance-to-other-zones], @racket[place-on-forest-zone], @racket[avoid-forest-zone], @racket[avoid-cliff-zone], @racket[min-distance-to-map-edge], @racket[min-distance-group-placement], @racket[temp-min-distance-group-placement], @racket[find-closest], @racket[find-closest-to-map-center], @racket[find-closest-to-map-edge], @racket[require-path], @racket[force-placement], @racket[actor-area], @racket[actor-area-radius], @racket[override-actor-radius-if-required], @racket[actor-area-to-place-in], @racket[avoid-actor-area], @racket[avoid-all-actor-areas], @racket[enable-tile-shuffling] and @racket[set-facet].

 Game versions: All

 Arguments:

 type - object constant (see: @hyperlink["https://docs.google.com/document/u/0/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/mobilebasic#h.nvxriamulybh"]{Objects})

 Place the specified object, according to the chosen attributes.

 Example: Give all players a town center.
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (create-object 'GOLD
                (number-of-objects 10))
 ]
}

@defform[(create-object-group name body ...) #:contracts ([type any/c] [body any/c])]{
 Section: @racket[<OBJECTS-GENERATION>].

 Attributes: @racket[add-object].

 Game versions: DE only
 Arguments:

 GroupName - text
 @itemlist[
 @item{ANY characters are valid; convention is to use uppercase letters and underscores}
 ]

 List a selection of objects with probabilities. When the chosen constant name is used in your script, an object will be chosen from the group at random, using the specified probabilities.

 @itemlist[
 @item{If a group of objects is placed, each one will be individually randomized.}
 @item{If used with @racket[set-place-for-every-player], the group will be randomized each time, so a group generally should not contain objects with different resource amounts or different gameplay effects.}
 @item{BUG:  The % currently doesn't work; all objects in the group are equally likely regardless of what number you specify.}
 ]

 Example: Create a pool of all cow variations and then generate clusters of mixed cow variants.
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (create-object-group 'HERDABLE_A
                      (add-object 'DLC_COW 25)
                      (add-object 'DLC_COW_B 25)
                      (add-object 'DLC_COW_C 25)
                      (add-object 'DLC_COW_D 25))
 (create-object 'HERDABLE_A
                (number-of-objects 6)
                (number-of-groups 24))
 ]
}






