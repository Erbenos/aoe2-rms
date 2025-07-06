#lang scribble/manual

@(require(except-in (for-label aoe2-rms) #%module-begin))

@title[#:tag "attributes"]{Attributes}

@defproc[(random-placement)
         void?]{
 Sections: @racket[<PLAYER-SETUP>].

 Mutually exclusive with: @racket[grouped-by-team]

 Game versions: All

 Players are positioned in a circle with some variation. This is the default, and will apply even if
 you do not type it.

 Example:
 @racketmod[
 aoe2-rms

 <PLAYER-SETUP>
 (random-placement)
 ]
}

@defproc[(grouped-by-team) void?]{
 Sections: @racket[<PLAYER-SETUP>].

 Mutually exclusive with: @racket[random-placement]

 Game versions: UP/HD/DE

 Requires: Team Together box ticked in the lobby (on by default)

 Players of the same team are positioned in close proximity to each other. Distance between
 team members is double the @racket[base-size] used in @racket[create-player-lands].

 Example:
 @racketmod[
 aoe2-rms

 <PLAYER-SETUP>
 (grouped-by-team)
 ]
}

@defproc[(direct-placement) void?]{
 Sections: @racket[<PLAYER-SETUP>].

 Game versions: UP/DE

 Allows the @racket[land-position] attribute in @racket[create-land] to be used in combination with the
 @racket[assign-to-player] or @racket[assign-to] attributes to individually position players at exact positions on the
 map.

 @itemlist[
 @item{On UP, !P will be appended to the map name in the objectives window.}
 @item{On UP, it can be used in combination with @racket[random-placement] / @racket[grouped-by-team] but it
   only works when using @racket[land-position]}
 @item{
   On DE, it disables @racket[random-placement] and @racket[grouped-by-team], but doesn't necessarily
   require @racket[land-position] - it is possible to just specify borders instead. If used with
   @racket[create-player-lands], these lands will be positioned entirely at random (ignoring the
   normal circular positioning), so this is usually not desirable.}
 ]

 Example: Directly place player 1 at the center of the map (50%, 50%)
 @racketmod[
 aoe2-rms

 <PLAYER-SETUP>
 (direct-placement)

 <LAND-GENERATION>
 (create-land
  (terrain-type 'DESERT)
  (land-percent 3)
  (land-position 50 50)
  (assign-to-player 1))
 ]
}

@defproc[(nomad-resources) void?]{
 Sections: @racket[<PLAYER-SETUP>].

 Game versions: UP/HD/DE

 Adds the cost of a town center (275 Wood, 100 Stone) to every player's starting resources. Use
 this in your custom nomad map if you want players to be able to build a town center without first
 gathering wood.
 @itemlist[
 @item{In DE, this adds the actual cost of a town center for the player's civilization. ie. Incas
   only get an extra 85 stone.}
 ]

 Example:
 @racketmod[
 aoe2-rms

 <PLAYER-SETUP>
 (nomad-resources)
 ]
}

@defproc[(force-nomad-treaty) void?]{
 Sections: @racket[<PLAYER-SETUP>].

 Game versions: DE only

 Activates a treaty period on nomad maps which lasts until every player has completed a town
 center or until 5 min have elapsed, whichever occurs first. Nomad treaty prevents combat and
 prevents construction within 10 tiles of another player's town center (foundation).

 @itemlist[
 @item{
   The border of the 10 tile radius is visible in explored tiles, which makes finding enemy
   town centers much easier. For this reason, nomad maps for tournament games often
   intentionally choose not to have a nomad treaty, while instead having rules against early
   villager fighting.
  }
 ]

 Example:
 @racketmod[
 aoe2-rms

 <PLAYER-SETUP>
 (nomad-resources)
 (force-nomad-treaty)
 ]
}

@defproc[(behavior-version [version-number any/c]) void?]{
 Sections: @racket[<PLAYER-SETUP>].

 Game versions: DE only

 Arguments:

 @itemlist[
 @item{
   version-number - number (0-2) (default: 0)
   @itemlist[
 @item{0 is classic behavior, and is the default}
 @item{1 is new behavior}
 @item{2 supposedly changes the behavior of object placement for per-player lands, but
     there have been no observed or noticeable differences}
 ]}
 ]

 Used for versioning changes that might affect how existing maps generate. Changes land
 generation such that when specifying @racket[number-of-tiles] or @racket[land-percent], the square amount
 covered by the @racket[base-size] is included in the total, rather than being additive. Also fixes a bug
 where land order would influence the generation.

 @itemlist[
 @item{This command can be used anywhere in your script. Player setup seems like an
   appropriate place to put it, so it is listed here.}
 @item{May be used in the future to gate off more fixes and changes that might break
   backwards compatibility.}
 @item{To update an old map, you must increase @racket[number-of-tiles] by (1+@racket[base-size]*2)² to get
   the same number of tiles as you previously had.
   @itemlist[
 @item{You also should increase any sub-100 @racket[land-percent] by an amount that varies
     with map size.}
 ]
  }
 ]

 Example: Activate new land generation behavior in your script and observe that your lands get smaller.
 @racketmod[
 aoe2-rms

 (behavior-version 1)
 <LAND-GENERATION>
 (create-player-lands
  (terrain-type 'DLC_BLACK)
  (number-of-tiles 250)
  (base-size 12))
 ]
}

@defproc[(override-map-size [side-length any/c]) void?]{
 Sections: @racket[<PLAYER-SETUP>].

 Game versions: DE only

 Arguments:

 @itemlist[
 @item{
   side-length - number (36-480) (default: use size set in lobby) (see: @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.qannz915qgy5"]{Map sizes})
   @itemlist[@item{values smaller than 36 or larger than 480 will clamp to those limits}]
  }
 ]

 Used to manually adjust the square dimensions of the map. This is used to make some of the
 official water maps one size larger than the size selected in the lobby.
 @itemlist[
 @item{Only one argument is accepted, so you are still restricted to square maps.}
 @item{This command can be used anywhere in your script. For general usage it should be
   used prior to any land generation, which is why it is listed here.}
 @item{Affects the scaling of elevation (@racket[set-scale-by-size] / @racket[set-scale-by-groups]), terrains
   (@racket[set-scale-by-size] / @racket[set-scale-by-groups]), and objects (@racket[set-scaling-to-map-size]).}
 @item{Can theoretically be used multiple times. Land generation will be based on what the
   current size is at that point in the script.}
 @item{Does not influence the length of the wonder timer; it will only depend on the size set in the lobby.
   @itemlist[@item{This can be used to reduce the wonder timer in 8 player games, by having
                 players choose the tiny size in the lobby for a script that overrides the size to
                 something suitable for 8 players.}]
   }]

 Example: Make the map always generate at a size of 100x100 tiles.
 @racketmod[
 aoe2-rms

 (override-map-size 100)
 ]

 Example: Make a map generate somewhat larger than what is set in the lobby.
 @racketmod[
 aoe2-rms

 (%cond ['TINY_MAP (override-map-size 144)]
        ['SMALL_MAP (override-map-size 168)]
        ['MEDIUM_MAP (override-map-size 200)]
        ['LARGE_MAP (override-map-size 220)]
        ['HUGE_MAP (override-map-size 240)]
        ['GIGANTIC_MAP (override-map-size 255)])
 ]
}

@defproc[(set-scale-by-size) void?]{
 Blocks: @racket[create-terrain] and @racket[create-elevation].

 Game versions: All

 Scales @racket[number-of-tiles] to the map size. Unscaled value refers to a 100x100 map (see: @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.qannz915qgy5"]{Map Sizes} for the scaling table).

 If you see a script scaling by both size and groups, only the final attribute will apply!

 @itemlist[
 @item{If you want to scale by both groups and size, use @racket[set-scale-by-groups] instead.}
 ]

 In @racket[<ELEVATION-GENERATION>], if you want to scale elevation by both groups and size, you must do so manually using @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.vs551a7tyxet"]{Conditionals}.

 BUG (AoC/UP/HD): the behavior of @racket[set-scale-by-size] and @racket[set-scale-by-groups] is inverted, with each attribute scaling elevation as the other one should. This bug is fixed in DE.

 Example: Create 4 hills which become larger on larger maps.  On a small map this will be 4 clumps with a total of 400*2.1 = 840 tiles.
 @racketmod[
 aoe2-rms

 <ELEVATION-GENERATION>
 (create-elevation 3
                   (base-terrain 'GRASS)
                   (number-of-tiles 400)
                   (number-of-clumps 4)
                   (set-scale-by-size))
 ]

 Example: Create 4 lakes which become larger on larger maps.  On a small map this will be 4 clumps with a total of 400*2.1 = 840 tiles.
 @racketmod[
 aoe2-rms

 <TERRAIN-GENERATION>
 (create-terrain 'WATER
                 (base-terrain 'GRASS)
                 (number-of-tiles 400)
                 (number-of-clumps 4)
                 (set-scale-by-size))
 ]
}

@defproc[(set-scale-by-groups) void?]{
 Blocks: @racket[create-terrain] and @racket[create-elevation].

 Game versions: All

 Mutually exclusive with: @racket[set-scale-by-size]

 Scales @racket[number-of-clumps] to the map size. Unscaled value refers to a 100x100 map (see: @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.qannz915qgy5"]{Map Sizes} for the scaling table).

 If you see a script scaling by both size and groups, only the final attribute will apply!.

 In @racket[<TERRAIN-GENERATION>], when used with @racket[number-of-tiles], the total tiles are also scaled to map size as well.

 In @racket[<ELEVATION-GENERATION>], unlike for terrains, for elevation this attribute does NOT increase the total tile count, If you want to scale elevation by both groups and size, you must do so manually using @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.vs551a7tyxet"]{Conditionals}.

 @itemlist[
 @item{BUG (AoC/UP/HD): the behavior of @racket[set-scale-by-size] and @racket[set-scale-by-groups] is inverted, with each attribute scaling elevation as the other one should. This bug is fixed in DE.}
 ]

 Example: Create 400 tiles worth of hills, with the number of hills scaling to map size.  On a small map this will be 4x2.1 = 8 clumps and a total of 400 tiles.
 @racketmod[
 aoe2-rms

 <ELEVATION-GENERATION>
 (create-elevation 4
                   (base-terrain 'GRASS)
                   (number-of-tiles 400)
                   (number-of-clumps 4)
                   (set-scale-by-groups))
 ]

 Example: Create 400 tiles worth of lakes, with the number of lakes AND the total number of tiles scaling to map size.  On a small map this will be 4x2.1 = 8 clumps with a total of 400*2.1 = 840 tiles.
 @racketmod[
 aoe2-rms

 <TERRAIN-GENERATION>
 (create-terrain 'WATER
                 (base-terrain 'GRASS)
                 (number-of-tiles 400)
                 (number-of-clumps 4)
                 (set-scale-by-groups))
 ]
}

@defproc[(spacing [amount any/c]) void?]{
 Blocks: @racket[create-elevantion].

 Game versions: All

 Arguments:
 @itemlist[
 @item{@racket[amount] - number (1+) (default: 1 - no spacing)}
 ]

 Number of tiles between each elevation level. Numbers larger than 1 will produce rings of flat terrain on each level of a hill.

 Example: Create one large large hill with increased spacing.
 @racketmod[
 aoe2-rms

 <ELEVATION-GENERATION>
 (create-elevation 7
                   (base-terrain 'GRASS)
                   (number-of-tiles 3000)
                   (spacing 4))
 ]
}

@defproc[(enable-balanced-elevation) void?]{
 Blocks: @racket[create-elevation].

 Game versions: DE only

 Removes the bias of hill placement towards the bottom (south) of the map. Default is disabled, so you should always include this attribute!
 Elevation will still be slightly biased towards the south, even with this attribute. See @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.a1p1k7mg0eak"]{Balanced Elevation Comparison} in the Appendix for a comparison with and without this attribute.

 Example: Spread a large number of hills fairly across the map.  Remove enable_balanced_elevation to see the difference.
 @racketmod[
 aoe2-rms

 <ELEVATION-GENERATION>
 (create-elevation 7
                   (base-terrain 'GRASS)
                   (number-of-tiles 9320)
                   (number-of-clumps 9320)
                   (enable-balanced-elevation))
 <TERRAIN-GENERATION>
 (create-terrain 'DESERT
                 (base-terrain 'GRASS)
                 (land-percent 100)
                 (number-of-clumps 9320)
                 (height-limits 1 7))
 ]
}

@defproc[(set-gaia-civilization [civ-number any/c]) void?]{
 Sections: @racket[<PLAYER-SETUP>].

 Game versions: DE only

 Arguments:

 @itemlist[
 @item{civ-number - number (0-53) (default: 0 - gaia) (see: @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.8ctucmcvyhyv"]{Civilizations})}
 ]

 Set the civilization for gaia to use.  This will affect the architectural style of any gaia buildings, and the appearance of any units that have regional variations.  It will also affect any civilization bonuses, upgrades and unique technologies (relevant especially for @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.yaqdimuqjsaj"]{battle royale})

 @itemlist[
 @item{The default gaia civ in DE uses the western European architectural style.}
 @item{This command can be used anywhere in your script.  Player setup seems like an appropriate place to put it, so I have listed it here.}
 @item{If used, gaia effects (see: @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.90ed1yz7qe0h"]{Effect Constants}) will no longer function when applied to units that can be player controlled.}
 @item{If used, gaia buildings with @racket[make-indestrucible] will be burning, so it is best not to use @racket[set-gaia-civilization] if you wish to use indestructible gaia buildings.}
 @item{If used multiple times, only the final instance will apply.}
 @item{Does not work in the scenario editor.}
 ]

 Example: Create a Lithuanian monument for gaia somewhere on the map
 @racketmod[
 aoe2-rms

 (set-gaia-civilization 35)

 <OBJECTS-GENERATION>
 (create-object 'MONUMENT)
 ]
}

@defproc[(ai-info-map-type [map-type any/c] [nomad? any/c] [michi? any/c] [show-type any/c]) void?]{
 Sections: @racket[<PLAYER-SETUP>].

 Game versions: All

 Arguments:
 @itemlist[
 @item{map-type - map type constant (see: @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.jxjsnahvu5u4"]{Map Types}) (default: CUSTOM)
   @itemlist[@item{Specify a standard map type that your map is similar to.}]}
 @item{nomad? - boolean (1 or 0) (default: 0)
   @itemlist[@item{Specify if your map is nomad style (no town center to start with).}
             @item{Always use this on nomad starts since it prevents issues where ally locations are revealed (fixed in DE)}]}
 @item{michi? - boolean (1 or 0) (default: 0)
   @itemlist[@item{Specify if your map is Michi style (forest completely separating players).}]}
 @item{show-type - boolean (1 or 0) (default: 0)
   @itemlist[@item{Specify if you want your chosen map type to be shown in the objectives window (only works in UP)}]
  }
 ]

 Provide information about the map to AIs.  If your map is not very similar to an existing map, it is best to leave out the command entirely, or to use CUSTOM as the map type.

 Example: A map that is a slightly modified version of Arabia and you want the objectives screen to say Arabia.
 @racketmod[
 aoe2-rms

 <PLAYER-SETUP>
 (ai-info-map-type 'ARABIA 0 0 1)
 ]
}

@defproc[(effect-amount [effect-type any/c] [type any/c] [attribute-type any/c] [amount any/c]) void?]{
 Sections: @racket[<PLAYER-SETUP>].

 Game versions: UP/DE

 Arguments:
 @itemlist[
 @item{effect-type - effect constant (see: @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.90ed1yz7qe0h"]{Effect Constants})}
 @item{type - object/resource/technology/effect constant (see: @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.nvxriamulybh"]{Objects}, @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.cym0hd55425r"]{Resource Constants}, @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.eo6nl4huxzuz"]{Technology Constants}, @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.2n1q8vynhc9o"]{Miscellaneous Constants}, @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.lvcoxxnz995p"]{Class Constants}, @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.6u6ogmgec4g"]{Advanced Genie Editor})}
 @item{attribute-type - attribute constant (see: @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.oumcl095iabt"]{Attribute Constants})}
 @item{amount - number
   @itemlist[@item{DE only: accepts floating-point values}]}
 ]

 Modify various aspects of the gamedata, specifically for your map.  See the linked guides for a better overview of the possibilities.

 @itemlist[
 @item{When modifying objects, you may need to target ALL hidden variations, one-by-one.}
 @item{If an object ends up with more than 32767 hitpoints, it is instantly destroyed. Be sure to consider in-game upgrades and civ bonuses.}
 @item{If you disable an object with this command, in-game techs/ages (unless disabled) may re-enable it. The civ tech tree may also override changes.
   (UP only) !C will be appended to the map name in the Objectives window.}
 @item{In vanilla UP only, the relevant constants must first be defined before use.}
 ]

 Example: Add 10000 starting food.
 @racketmod[
 aoe2-rms

 <PLAYER-SETUP>
 (effect-amount 'MOD_RESOURCE 'AMOUNT_STARTING_FOOD 'ATTR_ADD 10000)
 ]

 Example: Houses support 10/15/20/25 population in dark/feudal/castle/imperial age.
 @racketmod[
 aoe2-rms

 <PLAYER-SETUP>
 (effect-amount 'SET_ATTRIBUTE 'HOUSE 'ATTR_STORAGE_VALUE 10)
 (effect-amount 'SET_ATTRIBUTE 'HOUSE_F 'ATTR_STORAGE_VALUE 15)
 (effect-amount 'SET_ATTRIBUTE 'HOUSE_C 'ATTR_STORAGE_VALUE 20)
 (effect-amount 'SET_ATTRIBUTE 'HOUSE_I 'ATTR_STORAGE_VALUE 25)
 ]
}

@defproc[(effect-percent [effect-type any/c] [type any/c] [attribute-type any/c] [percentage any/c]) void?]{
 Sections: @racket[<PLAYER-SETUP>].

 Game versions: UP/DE

 Arguments:
 @itemlist[
 @item{effect-type - effect constant (see: @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.90ed1yz7qe0h"]{Effect Constants})}
 @item{type - object/resource/technology/effect constant (see: @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.nvxriamulybh"]{Objects}, @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.cym0hd55425r"]{Resource Constants}, @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.eo6nl4huxzuz"]{Technology Constants}, @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.2n1q8vynhc9o"]{Miscellaneous Constants}, @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.lvcoxxnz995p"]{Class Constants}, @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.6u6ogmgec4g"]{Advanced Genie Editor})}
 @item{attribute-type - attribute constant (see: @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.oumcl095iabt"]{Attribute Constants})}
 @item{percentage - number
   @itemlist[@item{DE only: accepts floating-point values}]}
 ]

 Same as @racket[effect-amount] but allows for greater precision.  The specified value is divided by 100 so that you can use decimal values.

 Example: Add 0.3 speed to all villagers (30/100 = 0.3)
 @racketmod[
 aoe2-rms

 <PLAYER-SETUP>
 (effect-percent 'ADD_RESOURCE 'VILLAGER_CLASS 'ATTR_MOVE_SPEED 30)
 ]

 Example: @hyperlink["https://snippets.aoe2map.net/GbetoEliteRattanArcherChemistryThalassocracy"]{Nerf the slinging of resources by making tributing more inefficient and moving coinage to imperial age.}
}

@defproc[(guard-state [object-type any/c] [resource-type any/c] [resource-delta any/c] [flags any/c]) void?]{
 Sections: @racket[<PLAYER-SETUP>].

 Game versions: UP/DE

 Arguments:
 @itemlist[
 @item{object-type - object constant or class constant (see: @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.nvxriamulybh"]{Objects}, @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.lvcoxxnz995p"]{Class Constants}) for villagers use VILLAGER_CLASS instead of VILLAGER}
 @item{resource-type - resource amount constant (see: @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.cym0hd55425r"]{Resource Constants})}
 @item{resource-delta - number (default: 0)@itemlist[@item{DE only: accepts floating-point values}]}
 @item{flags - number (0-7) (default: 0)
   @itemlist[
 @item{0: no flags}
 @item{1: lose if you do not control the specified object-type}
 @item{2: activate a resource trickle of the resource-type at the level of resource-delta/100, as long as you control object-type}
 @item{4: invert the object-type requirement for the other flags}
 @item{add the values to apply multiple flags}
 ]}
 ]

 Set up additional lose conditions and/or resource trickles based on controlling or not controlling a specified object.
 @itemlist[
 @item{Only one @racket[guard-state] command can be active in your script!}
 @item{(UP only) If used, !G will be appended to the map name in the Objectives window, along with the guard state details}
 ]


 Example: Activate a guardstate on the king, to make a map regicide even in other game modes.
 @racketmod[
 aoe2-rms

 <PLAYER-SETUP>
 (guard-state 'KING 'AMOUNT_GOLD 0 1)
 ]

 Example: Slowly drain a player's food while they do not control the monument.
 @racketmod[
 aoe2-rms

 <PLAYER-SETUP>
 (guard-state 'MONUMENT 'AMOUNT_FOOD -5 6)
 ]

 Example: Enable a small, relic-style gold trickle and configure players to be defeated if all villagers are lost.
 @racketmod[
 aoe2-rms

 <PLAYER-SETUP>
 (guard-state 'VILLAGER_CLASS 'AMOUNT_GOLD 10 3)
 ]
}

@defproc[(terrain-state [mode any/c] [parameter1 any/c] [parameter2 any/c] [flags any/c]) void?]{
 Sections: @racket[<PLAYER-SETUP>].

 Game versions: UP only

 Arguments:
 @itemlist[
 @item{mode - number (0) (default: 0)}
 @item{parameter1 - number (0) (default: 0)}
 @item{parameter2 - number (0) (default: 0)}
 @item{flags - number (0-7) (default: 0)
   @itemlist[
 @item{0: no flags}
 @item{1: enable building on shallows; also allows resources to be placed on shallows}
 @item{2: thinner blending of shallows and beach terrain}
 @item{4: changes ice blending to use shallows-style blending}
 @item{add the values to apply multiple flags}
 ]}
 ]

 Changes the shallows terrain to allow it to be buildable. Can also be used to modify shallows and ice blending properties. There may be further unknown and undocumented functionality.

 @itemlist[
 @item{Parameters 1 and 2 are unimplemented as far as we currently know, and the only known mode is 0, so just set the first three numbers to 0 if you use this command.}
 ]

 Example: Activate all flags to allow for buildable shallows with alternate blending.
 @racketmod[
 aoe2-rms

 <PLAYER-SETUP>
 (terrain-state 0 0 0 7)
 ]
}

@defproc[(weather-type [precipitation-style any/c] [live-color any/c] [fog-color any/c] [water-direction any/c]) void?]{
 Sections: @racket[<PLAYER-SETUP>].

 Game versions: UP only

 Arguments:
 @itemlist[
 @item{precipitation-style - number (-4 to 4) (default: 0)
   @itemlist[
 @item{0: no precipitation}
 @item{2: rain}
 @item{3: thunderstorm}
 @item{4: snow}
 @item{Precipitation goes west to east; use negative numbers for east to west.}
 ]}
 @item{live-color - number (0 to 255) (default: 0)
   @itemlist[
 @item{Color of terrain tinting in revealed areas.}
 @item{0: none; 1-255 refers to the @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0"]{color palette}.}
 ]}
 @item{fog-color - number (0 to 255) (default: 0)
   @itemlist[
 @item{Color of terrain tinting in the fog of war.}
 @item{0: none; 1-255 refers to the @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0"]{color palette}.}
 ]}
 @item{water-direction - number (-1 to 1) (default: 0)
   @itemlist[
 @item{Direction of animated water.}
 @item{0: random; 1: west to east; -1: east to west.}
 ]}
 ]

 Set up precipitation and terrain tinting.

 @itemlist[
 @item{It usually looks good to match the precipitation and water direction.}
 @item{It often makes sense to pick similar colors for live and fog tinting.}
 @item{Terrain tinting looks bad on streams and recordings, so you may want to leave it out.}
 @item{In DE, consider using @racket[color-correction] instead.}
 ]

 Example: Westward thunderstorm.
 @racketmod[
 aoe2-rms

 <PLAYER-SETUP>
 (weather-type -3 16 0 -1)
 ]
}

@defproc[(water-definition [type any/c]) void?]{
 Sections: @racket[<PLAYER-SETUP>].

 Game versions: DE only

 See also: @racket[color-correction], @racket[enable-waves]

 Arguments:

 type - water color correction constant (see: @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.71e8lxz43czw"]{Water Types}) (default: 0 (sunny daytime))

 Specify a water profile to apply on your map.  Each option applies different color correction, waves and reflections to 3D water.
 Not visible if the "Render 3D Water" setting is disabled.
 on UP, use @racket[weather-type] instead.
}


@defproc[(base-terrain [terrain-type any/c]) void?]{
 Blocks: @racket[create-elevation], @racket[create-terrain].

 Sections: @racket[<TERRAIN-GENERATION>].

 Game versions: All

 Arguments:
 @itemlist[
 @item{terrain-type - terrain constant (see: @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.a6v57wiwr7xp"]{Terrains}) (default: GRASS)}
 ]

 BUG (DE): Does not default to GRASS, so make sure to specify the base terrain.

 In @racket[<LAND-GENERATION>], specifies a terrain to initially fill the map. Maps with rivers going through them or oceans on the outside usually use water. Maps with forest on the outside usually use forest terrain.

 In @racket[<ELEVATION-GENERATION>], terrains on which the hill(s) should generate.  If you have multiple terrains you want hills on, then you need multiple @racket[create-elevation] blocks.

 Note that you only need to consider terrains from @racket[<LAND-GENERATION>], as @racket[<TERRAIN-GENERATION>] occurs after elevation has already been placed.

 In @racket[<TERRAIN-GENERATION>], specifies the base terrain on which you want to place your new terrain.

 Example: Fill the map with water.
 @racketmod[
 aoe2-rms

 <LAND-GENERATION>
 (base-terrain 'WATER)
 ]

 Example: Create one hill on water terrain.
 @racketmod[
 aoe2-rms

 <ELEVATION-GENERATION>
 (create-elevation 7
                   (base-terrain 'WATER)
                   (number-of-tiles 600))
 ]

 Example: Create a large clump of forest terrain on grass terrain, then create water on the forest
 @racketmod[
 aoe2-rms

 <TERRAIN-GENERATION>
 (create-terrain 'FOREST
                 (base-terrain 'GRASS)
                 (land-percent 10))

 (create-terrain 'WATER
                 (base-terrain 'FOREST))
 ]
}

@defproc[(base-layer [terrain-type any/c]) void?]{
 Blocks: @racket[create-elevation].

 Sections: @racket[<TERRAIN-GENERATION>], @racket[<LAND-GENERATION>].

 Game versions: DE only

 Accepts a terrain constant. See @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.a6v57wiwr7xp"]{Terrains}.

 Defaults to no layered terrain.

 In @racket[<TERRAIN-GENERATION>] and @racket[<LAND-GENERATION>], specify a terrain to layer on top of the map's @racket[base-terrain]. This layered terrain is visual only, and does not confer any terrain properties or object restrictions.

 @itemlist[
 @item{Must be used AFTER @racket[base-terrain].}
 @item{If used, you must specify the same @racket[base-layer] in @racket[create-elevation] if you want to generate elevation on the map base terrain.}
 ]

 In @racket[<ELEVATION-GENERATION>], use this attribute in addition to @racket[base-terrain] if (and only if) you specified a layer for the map base terrain at the beginning of @racket[<LAND-GENERATION>].

 Example: Initially fill the map with dirt3, and layer snow on top of that
 @racketmod[
 aoe2-rms

 <LAND-GENERATION>
 (base-terrain 'DIRT3)
 (base-layer 'SNOW)
 ]

 Example: Create one hill on water terrain.
 @racketmod[
 aoe2-rms

 <LAND-GENERATION>
 (base-terrain 'DIRT)
 (base-layer 'SNOW)

 <ELEVATION-GENERATION>
 (create-elevation 7
                   (base-terrain 'DIRT3)
                   (base-layer 'SNOW)
                   (number-of-tiles 9320)
                   (number-of-clumps 20))
 ]

 Example: Layer desert on grass, and then place water on the layered desert.
 @racketmod[
 aoe2-rms

 <TERRAIN-GENERATION>
 (create-terrain 'DESERT
                 (base-terrain 'GRASS)
                 (land-percent 10)
                 (terrain-mask 1))

 (create-terrain 'WATER
                 (base-layer 'DESERT))
 ]
}

@defproc[(beach-terrain [type any/c]) void]{
 Blocks: @racket[create-terrain].

 Game versions: DE only

 Arguments:
 type - terrain constant (see: @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.3bdjnf7tryyk"]{Terrains}) (default: BEACH)

 Specify a terrain that should be placed where the current terrain borders water.

 @itemlist[
 @item{If a non-beach terrain is specified, players will not be able to build docks on this coastline.}
 @item{If a water terrain is specified, it will fully replace the terrain specified in @racket[create-terrain], so this is NOT recommended.}
 @item{@bold{BUG:} @racket[beach-terrain] does not work when a @racket[<CONNECTION-GENERATION>] section is present.}
 ]

 Example: Create a dirt island with beaches that have vegetation.
 @racketmod[
 aoe2-rms

 <LAND-GENERATION>
 (base-terrain 'WATER)

 <TERRAIN-GENERATION>
 (create-terrain 'DIRT
                 (number-of-tiles 500)
                 (spacing-to-other-terrain-types 1)
                 (base-terrain 'WATER)
                 (beach-terrain 'DLC_BEACH2))
 ]
}

@defproc[(enable-waves [show-waves any/c]) void?]{
 Sections: @racket[<TERRAIN-GENERATION>].

 Game versions: DE only

 Arguments:
 @itemlist[
 @item{show-waves - boolean (1 or 0) (default: 1)}
 ]

 Enabled by default, so you only need to include it if you want to disable animated beach waves on your map. Waves are only visible if the player has "Render Beach Waves" turned on in the game settings.

 Example: Disable waves
 @racketmod[
 aoe2-rms

 <LAND-GENERATION>
 (enable-waves 0)
 ]
}

@defproc[(terrain-mask [layer any/c]) void?]{
 Blocks: @racket[create-terrain].

 Game versions: DE only

 Arguments:

 layer - number (1, 2) (default: 0 - no masking)

 @itemlist[
 @item{1 - new terrain is masked over the base terrain and inherits its properties.}
 @item{2 - new terrain is masked under the base terrain and provides new properties.}
 ]

 Enables terrain masking/layering for the terrain being created.  Terrain inherits all properties, placement restrictions, automatic objects (such as trees for forest terrains), minimap color, etc. from the terrain underneath (i.e., @racket[base-terrain] when masking over, or @racket[create-terrain] when masking under).

 @itemlist[
 @item{Terrain masking is a great way to blend terrains in a realistic and visually appealing manner.}
 @item{Masking layers 1 and 2 have different visual masking patterns.}
 @item{Terrain will have animated water if ANY of the component terrains are water.}
 @item{Legacy terrains that are already a blend of two texture files cannot be visually masked. They will contribute fully to the appearance of the final terrain. These terrains are: GRASS_SNOW, DIRT_SNOW, [dirt snow foundation], DLC_MOORLAND, DLC_JUNGLELEAVES, [road snow], [road fungus], DLC_DRYROAD, DLC_JUNGLEROAD, DLC_ROADGRAVEL.}
 @item{There are also some special cases with beach terrains, which may not always mask as expected (potentially a bug).}
 ]

 Example: Snow is masked on top of grass.  Will produce grass decoration objects.
 @racketmod[
 aoe2-rms

 <TERRAIN-GENERATION>
 (create-terrain 'SNOW
                 (base-terrain 'GRASS)
                 (land-percent 50)
                 (terrain-mask 1))
 ]

 Example: Snow is masked underneath grass.  Would produce snow decoration objects, if there were any in the game.
 @racketmod[
 aoe2-rms

 <TERRAIN-GENERATION>
 (create-terrain 'SNOW
                 (base-terrain 'GRASS)
                 (land-percent 50)
                 (terrain-mask 2))
 ]
}

@defproc[(spacing-to-other-terrain-types [distance any/c]) void]{
 Blocks: @racket[create-terrain].

 Game versions: All

 Arguments:

 distance - number (default: 0)

 Minimum distance that this terrain will stay away from other terrain types. Only considers existing terrains at the time of generation — terrains generated later will need their own spacing. Terrains will not stay away from the same terrain type created previously. This requires the use of an intermediate placeholder terrain. Also affects the distance that the terrain will stay away from cliffs (because cliffs generate their own terrain underneath them — terrain 16). When used with @racket[set-flat-terrain-only], it also affects the distance that the terrain will stay away from slopes.

 Example: Create a lake, and then fill the rest of the map with a forest which stays 10 tiles away from the water.
 @racketmod[
 aoe2-rms

 <TERRAIN-GENERATION>
 (create-terrain 'WATER
                 (base-terrain 'GRASS)
                 (land-percent 10))

 (create-terrain 'FOREST
                 (base-terrain 'GRASS)
                 (spacing-to-other-terrain-types 10)
                 (land-percent 100))
 ]
}

@defproc[(spacing-to-specific-terrain [type any/c] [distance any/c]) void?]{
 Blocks: @racket[create-terrain].

 Game versions: DE only.

 Arguments:

 type - terrain constants (see: @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.3bdjnf7tryyk"]{Terrains})

 distance - number (default: 0)

 Minimum distance that this terrain will stay away from a specific terrain.

 @itemlist[
 @item{Can be used multiple times to avoid multiple terrain types.}
 @item{Only considers existing terrains at the time of generation - terrains generated later will need their own spacing.}
 @item{Cannot be used to avoid the terrain currently being placed.  Doing this will prevent the terrain from being placed at all.}
 @item{@racket[spacing-to-other-terrain-types] takes precendence if larger.}
 ]

 Example: Generate forest that stays away from various terrains.

 @racketmod[
 aoe2-rms

 <TERRAIN-GENERATION>
 (create-terrain 'FOREST
                 (base-terrain 'GRASS)
                 (land-percent 20)
                 (number-of-clumps 30)
                 (spacing-to-specific-terrain 'WATER 15)
                 (spacing-to-specific-terrain 'SHALLOW 8)
                 (spacing-to-specific-terrain 'ICE 6)
                 (spacing-to-specific-terrain 'DESERT 3))
 ]
}

@defproc[(set-flat-terrain-only) void]{
 Blocks: @racket[create-terrain].

 Game versions: All

 Requires: @racket[spacing-to-other-terrain-types] > 0.

 The terrain will avoid sloped tiles by the distance specified in @racket[spacing-to-other-terrain-types].
 Only works when a distance of at least 1 has been specified.

 Example: Create a hill where the bottom and top are desert, but the slope is grass
 @racketmod[
 aoe2-rms

 <ELEVATION-GENERATION>
 (create-elevation 7 (base-terrain 'GRASS) (number-of-tiles 3000) (number-of-clumps 1))

 <TERRAIN-GENERATION>
 (create-terrain 'DESERT
                 (base-terrain 'GRASS)
                 (land-percent 10)
                 (number-of-clumps 9320)
                 (spacing-to-other-terrain-types 1)
                 (set-flat-terrain-only))
 ]
}

@defproc[(terrain-type [type any/c]) void?]{
 Blocks: @racket[create-player-lands], @racket[create-land].

 Game versions: All

 Arguments:
 @itemlist[
 @item{type - terrain constant (see: @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.a6v57wiwr7xp"]{Terrains}) (default: GRASS)}
 ]

 Specify which terrain the land should have.

 Example: Create player lands made of dirt.
 @racketmod[
 aoe2-rms

 <LAND-GENERATION>
 (create-player-lands
  (terrain-type 'DIRT)
  (land-percent 20))
 ]
}

@defproc[(land-percent [percentage any/c]) void?]{
 Blocks: @racket[create-player-lands], @racket[create-land].

 Game versions: All

 Mutually exclusive with: @racket[number-of-tiles]

 In @racket[<LAND-GENERATION>], percentage of the total map that the land should grow to cover.
 If land growth is constrained by borders or other lands, lands may be smaller than specified.
 For player lands (@racket[create-player-lands]) the percentage is divided equally between all players.
 Valid values are 0 - 100, inclusive, defaults to 100.

 In @racket[<TERRAIN-GENERATION>], percentage of the total map allocated to given command.  If @racket[number-of-clumps] is specified, this value is divided equally among the clumps.
 Terrain will only be replaced where the appropriate @racket[base-terrain] or @racket[base-layer] is present, and will only replace the specified number of individual clumps, so it will not necessarily fill 100% of the map if set to 100.

 Example: Allocate 20% total of the map toward player lands
 @racketmod[
 aoe2-rms

 <LAND-GENERATION>
 (create-player-lands
  (terrain-type 'DIRT)
  (land-percent 20))
 ]

 Example: Create a desert that covers 50% of the map
 @racketmod[
 aoe2-rms

 <TERRAIN-GENERATION>
 (create-terrain 'DESERT
                 (base-terrain 'GRASS)
                 (land-percent 50))
 ]
}

@defproc[(number-of-tiles [amount any/c]) void?]{
 Blocks: @racket[create-player-lands], @racket[create-land], @racket[create-elevation].

 Game versions: All

 Mutually exclusive with: @racket[land-percent]

 In @racket[<LAND-GENERATION>], can specify the fixed number of tiles that the land should grow by, default being the entire land.

 @itemlist[
 @item{Total size of the land is @racket[number-of-tiles] in addition to the square origin specified by @racket[base-size].}
 @item{When using @racket[behavior-version] 1, the square origin is included in the total @racket[number-of-tiles], resulting in smaller lands, unless compensated for.}
 @item{For player lands (@racket[create-player-lands]) each player is given the specified number of tiles.}
 ]

 In @racket[<ELEVATION-GENERATION>] or @racket[<TERRAIN-GENERATION>], specifies total base tile count, defaulting to 120 on tiny maps.
 If @racket[number-of-clumps] is specified, this value is divided equally among the clumps.

 Example: Give every player 300 tiles.
 @racketmod[
 aoe2-rms

 <LAND-GENERATION>
 (create-player-lands
  (terrain-type 'DIRT)
  (number-of-tiles 300))
 ]

 Example: Create one hill on grassy terrain.
 @racketmod[
 aoe2-rms

 <ELEVATION-GENERATION>
 (create-elevation 7
                   (base-terrain 'GRASS)
                   (number-of-tiles 600))
 ]

 Example: Create 500-tile lake.
 @racketmod[
 aoe2-rms

 <TERRAIN-GENERATION>
 (create-terrain 'WATER
                 (base-terrain 'GRASS)
                 (number-of-tiles 500))
 ]
}

@defproc[(number-of-clumps [amount any/c]) void?]{
 Blocks: @racket[create-terrain].

 Game versions: All

 @itemlist[
 @item{Amount - number (default: 1)}
 @item{A maximum of 9320 should be used when also specifying @racket[set-scale-by-groups].}
 @item{Number of individual terrain patches to create.}
 @item{If clumps are larger than expected (or total count is lower than expected), several adjacent clumps have merged.}
 ]

 Example: Create 4 hills of 100 tiles each.
 @racketmod[
 aoe2-rms

 <ELEVATION-GENERATION>
 (create-elevation 3
                   (base-terrain 'GRASS)
                   (number-of-tiles 400)
                   (number-of-clumps 4))
 ]

 Example: Create 40 forest clumps on grass terrain.
 @racketmod[
 aoe2-rms

 <TERRAIN-GENERATION>
 (create-terrain 'FOREST
                 (base-terrain 'GRASS)
                 (land-percent 20)
                 (number-of-clumps 40))
 ]
}

@defproc[(cliff-type [type any/c]) void?]{
 Sections: @racket[<CLIFF-GENERATION>].

 Game versions: DE only

 Arguments:
 cliff-type - cliff type constant (see: @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.uow2rvrpkup5"]{Cliff Types}) (default: gray granite cliffs)

 Choose the color of the cliffs to match the theme of your map.

 @itemlist[
 @item{Currently the following are available:}
 @item{@racket[CT_GRANITE]}
 @item{@racket[CT_DESERT]}
 @item{@racket[CT_SNOW]}
 @item{@racket[CT_MARBLE]}
 @item{@racket[CT_LIMESTONE]}
 ]

 Example: Make the cliffs brown to match dirt and desert terrains.
 @racketmod[
 aoe2-rms

 <CLIFF-GENERATION>
 (cliff-type 'CT_DESERT)
 ]
}

@defproc*[([(min-number-of-cliffs [amount any/c]) void?]
           [(max-number-of-cliffs [amount any/c]) void?])]{
 Sections: @racket[<CLIFF-GENERATION>].

 Game versions: All

 Arguments:
 amount - number (default: min=3, max=8)

 @itemlist[
 @item{Set the minimum number of distinct cliffs to create.}
 @item{The actual number of cliffs is chosen at random from between min (inclusive) and max (exclusive).}
 @item{Does not scale with map size, so you must do so manually using @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.vs551a7tyxet"]{Conditionals}.}
 @item{Make sure min does not exceed max.}
 ]

 Example: Create 5-7 cliffs on your map.
 @racketmod[
 aoe2-rms

 <CLIFF-GENERATION>
 (min-number-of-cliffs 5)
 (max-number-of-cliffs 8)
 ]
}

@defproc*[([(min-length-of-cliff [length any/c]) void?]
           [(max-length-of-cliff [length any/c]) void?])]{
 Sections: @racket[<CLIFF-GENERATION>].

 Game versions: All

 Arguments:
 length - number (3+) (default: min=5, max=9)

 Sets the minimum length of a cliff, in cliff segments.

 Cliff lengths are chosen at random from between min and max (inclusive).

 @itemlist[
 @item{The unit is NOT tiles, but "cliff segments": length 3 = 12 tiles, 4 = 15 tiles, 5 = 18 tiles, etc.}
 @item{Minimum must be at least 3 for cliffs to appear at all.}
 @item{Cliffs may end up shorter than expected if they run out of space.}
 @item{Make sure min does not exceed max, otherwise the game will crash.}
 ]

 Example: Create exactly 10 cliffs with lengths 12-18 tiles
 @racketmod[
 aoe2-rms

 <CLIFF-GENERATION>
 (min-number-of-cliffs 10)
 (max-number-of-cliffs 10)
 (min-length-of-cliff 3)
 (max-length-of-cliff 5)
 ]
}

@defproc[(cliff-curliness [percentage any/c]) void?]{
 Sections: @racket[<CLIFF-GENERATION>].

 Game versions: All

 Arguments:
 percentage - number (0-100) (default: 36)

 The chance that a cliff changes direction at each segment. Use low values for straight cliffs and high values for curly cliffs.

 Example: Create cliffs that are more curly than usual.
 @racketmod[
 aoe2-rms

 <CLIFF-GENERATION>
 (min-number-of-cliffs 10)
 (max-number-of-cliffs 10)
 (min-length-of-cliff 10)
 (max-length-of-cliff 10)
 (cliff-curliness 50)
 ]
}

@defproc[(min-distance-cliffs [distance any/c]) void?]{
 Sections: @racket[<CLIFF-GENERATION>].

 Game versions: All

 Arguments:
 distance - number (default: 2)

 Minimum distance in "cliff units" between separate cliffs. 0 is 0 tiles, 1 is 3 tiles, 2 is 6 tiles, etc.

 Example: Create cliffs that are more curly than usual.
 @racketmod[
 aoe2-rms

 <CLIFF-GENERATION>
 (min-number-of-cliffs 9999)
 (max-number-of-cliffs 9999)
 (min-distance-cliffs 1)
 ]
}

@defproc[(min-terrain-distance [distance any/c]) void?]{
 Sections: @racket[<CLIFF-GENERATION>].

 Game versions: All

 Arguments:
 distance - number (default: 2)

 Minimum distance in "cliff units" that cliffs will avoid water terrains by. 0 is 0 tiles, 1 is 3 tiles, 2 is 6 tiles, etc.. Note that this only considers terrains from @racket[<LAND-GENERATION>], as @racket[<TERRAIN-GENERATION>] occurs after cliffs have already been placed.

 Example:  Fill the map with cliffs that stay only 3 tiles from water and 0 tiles from each other.
 @racketmod[
 aoe2-rms

 <LAND-GENERATION>
 (base-terrain 'WATER)
 (create-player-lands
  (terrain-type 'GRASS)
  (land-percent 100)
  (other-zone-avoidance-distance 10))

 <CLIFF-GENERATION>
 (min-number-of-cliffs 9999)
 (max-number-of-cliffs 9999)
 (min-distance-cliffs 0)
 (min-terrain-distance 1)
 ]
}

@defproc[(base-size [radius any/c]) void?]{
 Blocks: @racket[create-player-lands], @racket[create-land].

 Game versions: All

 Arguments:
 @itemlist[
 @item{radius - number (default: 3)}
 ]

 Square radius of the initially placed land origin, before any growth.

 The default of 3 results in a 7x7 land origin (49 tiles total).

 @racket[base-size] will produce a perfect square if used with @racket[land-percent] 0 or @racket[number-of-tiles] 0.

 @racket[base-size] is the minimum distance that a land will be placed from the edge of the map.

 Land bases are placed sequentially, so if they are large and overlap, the land placed last will be the one visible in the overlapping region.

 Non-player land bases will not overlap with each other, unless...

 If @racket[base-size] for non-player lands is too large, the land will fail to find a valid position and will be placed at the center of the map, overlapping any other lands at the center.

 Example: Create a 13x13 square of ice
 @racketmod[
 aoe2-rms

 <LAND-GENERATION>
 (create-land
  (terrain-type 'ICE)
  (base-size 6)
  (number-of-tiles 0))
 ]
}

@defproc[(set-circular-base) void?]{
 Blocks: @racket[create-player-lands], @racket[create-land].

 Game versions: All

 The square land origin becomes a circle of the size that would be exactly inscribed by the square.

 Land origins with a @racket[base-size] of 3 or smaller will still be a perfect square, while larger bases will be more obviously circular.
 Can be used to produce a perfect circle if combined with @racket[land-percent] 0 or @racket[number-of-tiles] 0.

 Example: Create a 12x12 circle of desert for each player
 @racketmod[
 aoe2-rms

 <LAND-GENERATION>
 (create-player-lands
  (terrain-type 'DESERT)
  (land-percent 0)
  (base-size 12)
  (set-circular-base))
 ]
}

@defproc[(generate-mode [mode any/c]) void?]{
 Blocks: @racket[create-land].

 Game versions: DE only

 Arguments:

 mode - boolean (1 or 0) (default: 0 - lands are not placed in corners)

 By default, lands are positioned at random in a cross-shaped area, and will never be in the corners. Setting the generate mode to 1 will allow lands to be randomly positioned anywhere, including the corners.

 @itemlist[
 @item{No effect for @racket[create-player-lands].}
 @item{No effect when using @racket[assign-to-player] or @racket[assign-to] for @racket[create-land], unless @racket[direct-placement] is specified in @racket[<PLAYER-SETUP>].}
 ]

 Example: Create 4 ponds that can appear anywhere, including the corners.

 @racketmod[
 aoe2-rms

 <LAND-GENERATION>
 (create-land
  (generate-mode 1)
  (terrain-type 'WATER)
  (land-percent 1))
 (create-land
  (generate-mode 1)
  (terrain-type 'WATER)
  (land-percent 1))
 (create-land
  (generate-mode 1)
  (terrain-type 'WATER)
  (land-percent 1))
 ]
}

@defproc[(land-position [percentage-x any/c] [percentage-y any/c]) void?]{
 Blocks: @racket[create-land].

 Game versions: All

 Arguments:
 @itemlist[
 @item{percentage-x - number (0-100) (default: random*)
   X is the axis running from the top (southwest) to the bottom (northeast)}
 @item{percentage-y - number (0-99) (default: random*)
   Y is the axis running from the left (northwest) to right (southeast)}
 ]

 * Lands without @racket[land-position] will have their randomly chosen origin in a cross-shaped area and will never be in the corners.

 Specify the exact origin point for a land, as a percentage of total map dimensions.

 @itemlist[
 @item{@racket[land-position] 50 50 is the center of the map.}
 @item{@racket[land-position] 0 0 is the west corner, 100 99 is the east corner, 100 0 is the north corner, 0 99 is the south corner.}
 ]

 Ignores border restrictions.

 If placed outside of specified borders, the land will not grow beyond its @racket[base-size].

 Disabled for @racket[create-player-lands].

 Disabled when using @racket[assign-to-player] or @racket[assign-to] for @racket[create-land], unless @racket[direct-placement] is specified in @racket[<PLAYER-SETUP>].

 Positions outside of the map can theoretically be used if the crash conditions are avoid?ed.

 Note: 100 for the Y coordinate (or anything outside the map) will crash the game if your map uses @racket[<CONNECTION-GENERATION>] and has a connection that needs to reach this land specifically, or if the land uses @racket[assign-to-player].

 Example: Create a lake in the center of the map
 @racketmod[
 aoe2-rms

 <LAND-GENERATION>
 (create-land
  (terrain-type 'WATER)
  (land-percent 10)
  (land-position 50 50))
 ]
}

@defproc[(circle-radius [radius any/c] [variance any/c]) void?]{
 Blocks: @racket[create-player-lands].

 Game versions: DE only

 External reference: Official DE Documentation

 Arguments:
 @itemlist[
 @item{radius - number (1-50)
   It is a percentage of map width.
   0 will disable @racket[circle-radius].
   The standard radius for unconstrained lands is around 40.
   Values larger than 50 will tend to force players towards the extreme edges and corners of the map.}
 @item{variance - number (default: 0)
   0 is a perfect circle with no variance.
   20 seems to be close to the standard amount of variance when not using @racket[circle-radius].
   Very large values will tend to force players towards the corners of the map.
   Each player will vary independent of the others.}
 ]

 Used in @racket[create-player-lands] to position the player lands in a circle with equal distance to the center, with specified variance.

 @racket[circle-radius] ignores any specified borders when placing the land origins, but land growth will still be constrained by borders.

 There is also a command called @racket[circle-placement] which is used in the standard maps and listed in the official documentation. That command is non-functional.

 If used for multiple unique @racket[create-player-lands] commands, only the final radius will apply.

 BUG: if used for multiple player lands while also using @racket[grouped-by-team], the additional land positions will not generate properly.

 If used for @racket[create-land], it will still apply to player lands normally.

 See Circle Radius Comparison in the appendix for a comparison of not using @racket[circle-radius] to a radius with no variance.

 Example: Place player lands in a perfect circle close to the center of the map.
 @racketmod[
 aoe2-rms

 <LAND-GENERATION>
 (create-player-lands
  (terrain-type 'DIRT)
  (number-of-tiles 100)
  (circle-radius 20 0))
 ]
}

@defproc*[
 ([(left-border [percentage any/c]) void?]
  [(right-border [percentage any/c]) void?]
  [(top-border [percentage any/c]) void?]
  [(bottom-border [percentage any/c]) void?])
 ]{
 Blocks: @racket[create-player-lands], @racket[create-land].

 Game versions: All

 Arguments:
 @itemlist[
 @item{percentage - number (0-99) (default: 0)}
 ]

 Specify a percentage of map width for land placement and growth to stay away from the given border.

 Left is southwest; right is northeast, top is northwest; bottom is southeast.

 There is a hard-coded feature that makes lands look like octagons instead of squares when constrained by borders.

 Borders shift the entire circle of all the player lands.

 You cannot have multiple rings of player lands with different borders; they will all be in the same circle.

 Due to rounding, the exact number of tiles that a given percentage value corresponds to may not be the same for each side.
 For example, to stop 2 tiles from the edge on a tiny (120x120) map, a value of 2 must be used for the top and left borders, but a value of 3 is needed for the bottom and right borders.

 Negative values can be used, as long as the land origin stays inside the map. To ensure this, do one of the following:
 @itemlist[
 @item{Specify a @racket[land-position] within the map}
 @item{Specify a sufficiently large @racket[base-size] (this may require manually scaling of @racket[base-size] with map size)}
 ]

 BUG: asymmetric borders for player lands can cause issues when the @racket[top-border] is larger than other borders (External reference: @hyperlink["http://aok.heavengames.com/cgi-bin/forums/display.cgi?action=ct&f=28,42496,0,365"]{RMS Border Bugs Exposed}). Avoid? this by always using another border along with @racket[top-border] when creating player lands.

 Example: Place all players in the top corner of the map.
 @racketmod[
 aoe2-rms

 <LAND-GENERATION>
 (create-player-lands
  (terrain-type 'DIRT)
  (land-percent 100)
  (bottom-border 60)
  (left-border 60))
 ]
}

@defproc[(border-fuzziness [border-adherence any/c]) void?]{
 Blocks: @racket[create-player-lands], @racket[create-land].

 Game versions: All

 Arguments:
 @itemlist[
 @item{border-adherence - number (0-100) (default: 20)}
 ]

 Specifies the extent to which land growth respects borders and actually stops at a border.

 Low values allow lands to exceed specified borders, giving ragged looking edges when land is constrained by borders.

 0 causes land growth to ignore borders entirely.

 100 (or any negative value) means that borders are fully respected, resulting in perfectly straight lands along borders.

 Example: Central desert with very fuzzy borders
 @racketmod[
 aoe2-rms

 <LAND-GENERATION>
 (create-land
  (terrain-type 'DESERT)
  (land-position 50 50)
  (land-percent 100)
  (left-border 40)
  (right-border 40)
  (top-border 40)
  (bottom-border 40)
  (border-fuzziness 2))
 ]
}

@defproc[(clumping-factor [factor any/c]) void?]{
 Blocks: @racket[create-player-lands], @racket[create-land].

 Game versions: All

 In @racket[<LAND-GENERATION>], defaults to 8, useful range being about 0-40. The extent to which land growth prefers to clump together near existing tiles. Moderate values (11-40) create rounder lands, while low values (0-10) create more irregular lands, and high values (40+) create lands that extend in one direction away from the origin. Negative values create extremely snakey lands, and are generally not recommended.

 In @racket[<TERRAIN-GENERATION>], defaults to 20, useful range being about 0-25. The extent to which terrain tiles prefer to be together next to other tiles of the same clump.  Moderate values (5-25) create rounder terrain patches, while low values (0-5) create more irregular terrain patches.  Negative values create extremely snakey terrains.

 Example: Create irregularly shaped lake
 @racketmod[
 aoe2-rms

 <LAND-GENERATION>
 (create-land
  (terrain-type 'WATER)
  (land-percent 10)
  (clumping-factor 2))
 ]

 Example: Create a regularly-shaped bamboo forest
 @racketmod[
 aoe2-rms

 <TERRAIN-GENERATION>
 (create-terrain 'BAMBOO
                 (base-terrain 'GRASS)
                 (number-of-tiles 500)
                 (clumping-factor 20))
 ]
}

@defproc[(land-conformity [percentage any/c]) void?]{
 Blocks: @racket[create-player-lands], @racket[create-land].

 Game versions: All

 Arguments:

 percentage - number (-100 - 100)

 @itemlist[
 @item{0 is the same as not having this attribute}
 @item{Any negative number behaves the same}
 @item{100 causes this attribute to override the @racket[base-size] unless @racket[set-circular-base] is specified}
 @item{Useful ranges without @racket[set-circular-base]: 0~15, 25~35, 45~99, 100}
 @item{Useful ranges with @racket[set-circular-base]: 0~10, 20~30, 40~99, 100}
 ]

 Intended as a more potent version of @racket[clumping-factor], with higher values conforming more to the shape of the land origin set with @racket[base-size], and with negative numbers conforming less to it.

 @itemlist[
 @item{This attribute is currently buggy.  We have been advised to avoid using it.}
 @item{Appears to take the tile count of the land, and apply some math to it and then set a new "radius" for the land.  With circles the radius is roughly 1/2 what it should be at any given tile count; it's much closer to what it should be with squares.  Lands tend to not have any tiles, or very few, outside the “radius” above ~35 conformity.}
 ]
}

@defproc[(base-elevation [height any/c]) void?]{
 Blocks: @racket[create-player-lands], @racket[create-land].

 Sections: @racket[<ELEVATION-GENERATION>].

 Game versions: UP/HD/DE

 Arguments:
 @itemlist[
 @item{height - number (1-16) (default: 0 - not elevated)}
 ]

 In UP/HD elevations higher than 7 should not be used, because objects will fail to render properly.

 In DE, elevations higher than 7 can be used, but may cause terrain rendering issues for certain screen resolutions, especially if you go higher than about 16.

 Negative values maximally elevate a land (not recommended due to rendering issues).

 Elevate the entire land to the specified height.

 In HD/DE this will not work for lands with a water @racket[terrain-type].

 Up to a height of 9 the surrounding terrains will contain the slope, with even higher values, the remaining elevation occurs within the confines of the land.

 Example: Create a palm desert land with elevation 2.
 @racketmod[
 aoe2-rms

 <LAND-GENERATION>
 (create-land
  (terrain-type 'PALM_DESERT)
  (number-of-tiles 128)
  (base-elevation 2))

 <ELEVATION-GENERATION>
 ]
}

@defproc[(assign-to-player [player-number any/c]) void?]{
 Blocks: @racket[create-land].

 Game versions: All

 Mutually exclusive with: @racket[assign-to]

 Arguments:
 @itemlist[
 @item{player-number - number 1-8 (default: not assigned to any players)}
 ]

 Assign a land created with @racket[create-land] to one specific player, allowing you to place starting objects on that land for that player.

 Refers to lobby order - the first person in the lobby is player 1, even if they are not blue.

 If you want to support 8 players, you must individually assign lands to all 8 players.

 Lands assigned to players who are not playing will not be created.

 All lands belonging to players will be in a circle and @racket[land-position] will be ignored, unless @racket[direct-placement] is specified in @racket[<PLAYER-SETUP>].

 @racket[assign-to-player] 0 will make the land Gaia's player land (not recommended!).

 Negative values will create the land without assigning it to anyone.

 Example: Assign a desert land to player 1.
 @racketmod[
 aoe2-rms

 <LAND-GENERATION>
 (create-land
  (terrain-type 'DESERT)
  (land-percent 3)
  (assign-to-player 1))
 ]
}

@defproc[(assign-to [assign-target any/c]
                    [number any/c]
                    [mode any/c]
                    [flags any/c])
         void?]{
 Blocks: @racket[create-land].

 Game versions: UP/DE

 Mutually exclusive with: @racket[assign-to-player]

 Arguments:

 @itemlist[
 @item{assign-target - @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.n9ppujqraas6"]{AssignTargetConstant} (default: not assigned to any players)
   Options: AT_PLAYER, AT_COLOR, AT_TEAM}
 @item{number - varies depending on the @racket[assign-target]:
   @itemlist[
 @item{AT_PLAYER (1-8): player number (lobby order)}
 @item{AT_COLOR (1-8): player color}
 @item{AT_TEAM (-10, -4, -3, -2, -1, 0, 1, 2, 3, 4): team number (lobby order)}
 ]
   0 targets un-teamed players.
   Negative values target a player NOT on the specified team.
   -10 gives the land to any player.
   Teams containing only 1 player do not count as teams.
  }
 @item{mode - number (-1, 0)
   0: random selection (for AT_TEAM only)
   -1: ordered selection (for AT_TEAM only)}
 @item{flags - number (0–3)
   @itemlist[
 @item{0: no flags}
 @item{1: reset players already assigned before starting}
 @item{2: do not remember assigning this player}
 @item{3: both 1 and 2}
 ]
  }
 ]

 A more powerful version of @racket[assign-to-player].
 Assign a land created with @racket[create-land] to a specific player, allowing you to place starting objects for that player.

 If you want to support 8 players, you must individually assign lands for all players.

 Lands assigned to players who are not playing will not be created.

 All lands belonging to players will be in a circle and @racket[land-position] will be ignored unless @racket[direct-placement] is specified in @racket[<PLAYER-SETUP>].

 In DE and WK, the AssignTargetConstants are predefined; in vanilla UP they must be defined manually.

 Example: Assign a desert land to player 1.
 @racketmod[
 aoe2-rms
 <PLAYER-SETUP>
 (direct-placement)

 <LAND-GENERATION>
 (create-land
  (terrain-type 'DIRT)
  (number-of-tiles 128)
  (land-position 50 50)
  (assign-to 'AT_TEAM 1 0 0))
 ]
}

@defproc[(zone [zone-number any/c]) void?]{
 Blocks: @racket[create-player-lands], @racket[create-land].

 Game versions: All

 Mutually exclusive with: @racket[set-zone-by-team], @racket[set-zone-randomly]

 Arguments:

 @itemlist[
 @item{@racket[zone-number] — number}
 ]

 Sets a numeric zone for the land.

 Lands sharing the same zone can grow to touch each other.
 If two lands have different zones and @racket[other-zone-avoid?ance-distance] is specified, land growth will avoid? touching the other zone.

 Do not specify any zone if you want each player to be on their own island.

 By default, lands from @racket[create-player-lands] each get their own unique zone (PlayerNumber - 10). Lands created with @racket[create-land] all share the same zone (-10).

 @bold{BUG (AoC/UP/HD)}: @racket[zone] 99 will crash the game. This is fixed in DE.

 Example: All players are on the same continent, the rest of the map is water.
 @racketmod[
 aoe2-rms

 <LAND-GENERATION>
 (base-terrain 'WATER)
 (create-player-lands
  (terrain-type 'DIRT)
  (land-percent 60)
  (zone 1))
 ]
}

@defproc[(set-zone-by-team) void?]{
 Blocks: @racket[create-player-lands].

 Game versions: All

 Mutually exclusive with: @racket[zone], @racket[set-zone-randomly]

 For @racket[create-player-lands]. Assigns the same zone to all members of the same team.

 Lands sharing the same zone can grow to touch each other.
 If two lands have different zones, and @racket[other-zone-avoid?ance-distance] is specified, land growth will avoid? touching the other zone.

 If used with @racket[create-land], it will assign the land to the same zone as the team of player 1, even if the land is a non-player land or is assigned to a member of a different team. (This is not recommended!)

 Team zones correspond to (@racket[TeamNumber] - 9), for example, team 1 is in zone -8.

 Example: Team Islands.
 @racketmod[
 aoe2-rms

 <LAND-GENERATION>
 (base-terrain 'WATER)
 (create-player-lands
  (terrain-type 'DIRT)
  (land-percent 80)
  (set-zone-by-team)
  (other-zone-avoidance-distance 10)
  (left-border 10)
  (top-border 10)
  (right-border 10)
  (bottom-border 10))
 ]
}

@defproc[(set-zone-randomly) void?]{
 Blocks: @racket[create-player-lands], @racket[create-land].

 Game versions: All

 Mutually exclusive with: @racket[zone], @racket[set-zone-by-team]

 Lands with this attribute will randomly share zones with other lands.
 Lands sharing the same zone can grow to touch each other.
 If two lands have different zones, and @racket[other-zone-avoid?ance-distance] is specified, land growth will avoid? touching the other zone.

 Specifically, the land gets a random zone in the range -8 to (PlayerCount - 9). This means:

 • The land(s) will never share a zone with a land that is given a positive numeric zone or is a non-player land without a zone assigned.
 • The land(s) may share a zone with a land that has @racket[set-zone-randomly] or @racket[set-zone-by-team], or that has a manually specified zone in the correct range.
 • A non-player land with @racket[set-zone-randomly] will never share a zone with player 1 if player 1 is using their default zone of -9.

 Example: Archipelago-styled map where players might be on the same island with allies, enemies or nobody.
 @racketmod[
 aoe2-rms

 <LAND-GENERATION>
 (base-terrain 'WATER)
 (create-player-lands
  (terrain-type 'DIRT)
  (land-percent 80)
  (set-zone-randomly)
  (other-zone-avoidance-distance 10)
  (left-border 10)
  (top-border 10)
  (right-border 10)
  (bottom-border 10))
 ]
}

@defproc[(other-zone-avoidance-distance [tiles any/c]) void?]{
 Blocks: @racket[create-player-lands], @racket[create-land].

 Game versions: All

 Arguments:
 @itemlist[
 @item{tiles - number (default: 0)}
 ]

 Number of tiles away from a land with a different zone to stop land growth.
 Used to create river maps and island maps.

 To keep two lands separated, both lands must have this attribute.
 When different values are used for two lands, the smaller one applies.

 This attribute also keeps randomly positioned land origins/bases the specified distance apart (regardless of zone), but can be overridden by @racket[min-placement-distance].
 Land origins/bases may end up closer together or even touching if @racket[land-position] is specified, or if used for player lands when there are too many players crammed on too small of a map.

 Example: A rivers map where all players are separated by water, and there is a neutral island in the center.
 @racketmod[
 aoe2-rms

 <LAND-GENERATION>
 (base-terrain 'WATER)
 (create-player-lands
  (terrain-type 'GRASS)
  (land-percent 100)
  (other-zone-avoidance-distance 10))

 (create-land
  (terrain-type 'DIRT)
  (land-percent 100)
  (land-position 50 50)
  (zone 1)
  (other-zone-avoidance-distance 10))
 ]
}

@defproc[(min-placement-distance [tiles any/c]) void?]{
 Blocks: @racket[create-land].

 Game versions: All

 Arguments:
 @itemlist[
 @item{tiles - number (default: value of @racket[other-zone-avoid?ance-distance] (default: 0))}
 ]

 Number of tiles to stay away from the origins of previously created lands when randomly selecting an origin for this land.
 Previously undocumented and rarely used.

 If @racket[min-placement-distance] is not specified, land origins will be positioned such that there is at least @racket[other-zone-avoid?ance-distance] worth of space between the edges of the square origins.

 @racket[min-placement-distance] uses the center of the origins, so for a large @racket[base-size], lands may end up closer than an equivalent @racket[other-zone-avoid?ance-distance].

 If too large of a value is specified and the land cannot find a valid position, it will be placed in the center, regardless of other lands already in or near the center.

 No effect when @racket[land-position] is specified.
 No effect on player lands, unless @racket[direct-placement] is active in DE.

 Example: Create three deserts that have their origins at least 25 tiles from the other deserts.
 @racketmod[
 aoe2-rms

 <LAND-GENERATION>
 (create-land
  (terrain-type 'DESERT)
  (land-percent 1)
  (min-placement-distance 25))

 (create-land
  (terrain-type 'DESERT)
  (land-percent 1)
  (min-placement-distance 25))

 (create-land
  (terrain-type 'DESERT)
  (land-percent 1)
  (min-placement-distance 25))
 ]
}

@defproc[(land-id [identifier any/c]) void?]{
 Blocks: @racket[create-player-lands], @racket[create-land].

 Game versions: All

 @itemlist[
 @item{identifier — number (default: no id)}
 ]

 Assign a numeric label to a land, which can later be used to place objects specifically on that land with @racket{place-on-specific-land-id}.
 This is unrelated to any zone numbers.

 Multiple lands can have the same ID. In this case, objects will be placed on all of them.

 Must be used after @racket[assign-to-player] / @racket[assign-to] since they will reset the ID.

 Can theoretically be used for @racket[create-player-lands], but will disable the ability to use @racket[set-place-for-every-player] for object placement.
 This is sometimes useful for creating "fake" player lands to generate forests or ponds between players.

 Note that objects may be placed on surrounding terrain rather than the land itself, if the surrounding terrain supports the object placement.

 @racket[land-id] -9 assigns the land to be the player land of gaia (not recommended!)

 Example: Create a tiny snowy island and place a gold mine on it.
 @racketmod[
 aoe2-rms

 <LAND-GENERATION>
 (base-terrain 'WATER)

 (create-player-lands
  (terrain-type 'DIRT)
  (land-percent 0))

 (create-land
  (terrain-type 'SNOW)
  (land-percent 0)
  (land-id 13)
  (land-position 50 50))

 <OBJECTS-GENERATION>
 (create-object 'GOLD
                (place-on-specific-land-id 13))
 ]
}

@defproc[(color-correction [type any/c]) void?]{
 Sections: @racket[<TERRAIN-GENERATION>].

 Game versions: DE only

 See also: @racket[water-definition].

 Arguments:
 type - color correction constant (see: @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.ptggu3c4a8jy"]{Season Types}) (default: no color correction)

 @itemlist[
 @item{Specify a color correction type to apply on your map.}
 @item{Not visible if the "Map Lighting" setting is disabled.}
 @item{On UP, use @racket[weather-type] instead.}
 ]

 Example: Desert-themed lighting
 @racketmod[
 aoe2-rms

 <TERRAIN-GENERATION>
 (color-correction 'CC_DESERT)
 ]
}

@defproc[(set-avoid-player-start-areas [distance any/c]) void?]{
 Blocks: @racket[create-terrain].

 Game versions: All

 Arguments:
 distance - number (default: 0 - no avoidance)

 @itemlist[
 @item{Defaults to 13, if you specify the argument but omit the distance.}
 @item{This argument can ONLY be specified in DE.}
 @item{The terrain will avoid the origins of player lands by the specified number of tiles (with some variance).}
 @item{Useful to prevent forests or water terrain from being directly under the town center.}
 @item{In DE the distance can be adjusted.}
 ]

 Example: Forest Nothing with small clearings
 @racketmod[
 aoe2-rms

 <TERRAIN-GENERATION>
 (create-terrain 'FOREST
                 (base-terrain 'GRASS)
                 (land-percent 100)
                 (number-of-clumps 999)
                 (set-avoid-player-start-areas 2))
 ]
}

@defproc[(height-limits [min any/c] [max any/c]) void?]{
 Blocks: @racket[create-terrain].

 Game versions: All

 Arguments:
 min - number (default: none)
 Max - number (default: none)

 @itemlist[
 @item{The terrain will only be placed on tiles of height between min and max (inclusive).}
 @item{For most purposes, values between 0–7 are useful. 0 being the standard non-elevated height and 7 being the max height that can be produced by @racket[create-elevation].}
 ]

 Example: Create a hill and place desert terrain only on the slopes
 @racketmod[
 aoe2-rms

 <ELEVATION-GENERATION>
 (create-elevation 7 (base-terrain 'GRASS) (number-of-tiles 3000) (number-of-clumps 1))

 <TERRAIN-GENERATION>
 (create-terrain 'DESERT
                 (base-terrain 'GRASS)
                 (land-percent 100)
                 (number-of-clumps 9320)
                 (height-limits 1 6))
 ]
}

@defproc[(default-terrain-replacement [type any/c]) void?]{
 Blocks:
 @racket[create-connect-all-players-land], @racket[create-connect-teams-lands], @racket[create-connect-all-lands], @racket[create-connect-same-land-zones], @racket[create-connect-land-zones] and @racket[create-connect-to-nonplayer-land].

 Game versions: All

 Arguments:
 type - terrain constant (see: @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.3bdjnf7tryyk"]{Terrains})

 @itemlist[
 @item{Replace ALL terrain in the connection with the specified terrain.}
 @item{Useful for debugging purposes to quickly visualize all connection paths.}
 @item{Overrides any previously specified @racket[replace-terrain] attributes; does not override future attributes.}
 ]

 Example: Replace all connecting terrain with road, but replace water with shallows instead.
 @racketmod[
 aoe2-rms

 <LAND-GENERATION>
 (base-terrain 'WATER)
 (create-player-lands
  (land-percent 100)
  (other-zone-avoidance-distance 10))

 <CONNECTION-GENERATION>
 (create-connect-all-players-land
  (default-terrain-replacement 'ROAD)
  (replace-terrain 'WATER 'SHALLOW))
 ]

 Example: Replace everything with ice to see which routes the connections are taking.
 @racketmod[
 aoe2-rms

 <CONNECTION-GENERATION>
 (create-connect-all-lands
  (default-terrain-replacement 'ICE))
 ]
}

@defproc[(replace-terrain [old any/c] [new any/c]) voi?]{
 Blocks:
 @racket[create-connect-all-players-land], @racket[create-connect-teams-lands], @racket[create-connect-all-lands], @racket[create-connect-same-land-zones], @racket[create-connect-land-zones] and @racket[create-connect-to-nonplayer-land].

 Game versions: All

 Arguments:
 old - terrain constant (see: Terrains)
 new - terrain constant (see: Terrains)

 @itemlist[
 @item{If the specified terrain is part of the connection, replace it with the new terrain specified.}
 @item{This attribute can, and should, be used multiple times for different terrains.}
 @item{A terrain can be replaced with itself.}
 @item{Connections can pass through terrains even if they are not specified.}
 @item{DE: The old terrain refers to the terrain present at the beginning of @racket[<CONNECTION-GENERATION>] — even if that terrain has already been replaced by a previous command or attribute.}
 @item{This behavior can be disabled by using @racket[accumulate-connections].}
 ]

 Example: Replace several terrains in a connection
 @racketmod[
 aoe2-rms

 <CONNECTION-GENERATION>
 (create-connect-all-players-land
  (replace-terrain 'GRASS 'DIRT2)
  (replace-terrain 'FOREST 'LEAVES)
  (replace-terrain 'SNOW_FOREST 'GRASS_SNOW)
  (replace-terrain 'DIRT 'DIRT3)
  (replace-terrain 'WATER 'SHALLOW))
 ]
}

@defproc[(terrain-cost [type any/c] [cost any/c]) void?]{
 Blocks:
 @racket[create-connect-all-players-land], @racket[create-connect-teams-lands], @racket[create-connect-all-lands], @racket[create-connect-same-land-zones], @racket[create-connect-land-zones] and @racket[create-connect-to-nonplayer-land].

 Game versions: All

 Arguments:
 type - terrain constant (see: @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.3bdjnf7tryyk"]{Terrains})
 cost - number (0-4294967296) (default: 1)

 @itemlist[
 @item{0 (or any negative value) means the connection CANNOT pass through the specified terrain at all; thus, 1 is the "lowest" cost.}
 @item{For most usual applications, a cost range of 1-15 is sufficient.}
 @item{DE only: accepts floating-point values.}
 ]

 The cost of having the connection run through the specified terrain.

 @itemlist[
 @item{This attribute can be used multiple times for different terrains.}
 @item{If all costs are equal, connections will be straight lines.}
 @item{If some costs are higher, the algorithm prefers routes through lower cost terrains, even if longer.}
 @item{A cost of 0 prevents connection generation through that terrain; connections requiring crossing such terrain will not generate. Excessive use of this can slow down map generation time.}
 ]

 Example: Replace several terrains in a connection
 @racketmod[
 aoe2-rms

 <CONNECTION-GENERATION>
 (create-connect-all-players-land
  (replace-terrain 'GRASS 'ROAD)
  (replace-terrain 'FOREST 'LEAVES)
  (replace-terrain 'WATER 'SHALLOW)
  (replace-terrain 'MED_WATER 'SHALLOW)
  (replace-terrain 'DEEP_WATER 'SHALLOW)
  (terrain-cost 'GRASS 1)
  (terrain-cost 'FOREST 7)
  (terrain-cost 'WATER 7)
  (terrain-cost 'MED_WATER 12)
  (terrain-cost 'DEEP_WATER 15))
 ]
}

@defproc[(terrain-size [type any/c] [radius any/c] [variance any/c]) void?]{
 Blocks:
 @racket[create-connect-all-players-land], @racket[create-connect-teams-lands], @racket[create-connect-all-lands], @racket[create-connect-same-land-zones], @racket[create-connect-land-zones] and @racket[create-connect-to-nonplayer-land].

 Game versions: All

 Arguments:

 @itemlist[
 @item{terrain - terrain constant (see: @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.3bdjnf7tryyk"]{Terrains})}
 @item{radius - number (default: 1)}
 @item{variance - number (default: 0)}
 ]

 Given that a Ludicrously-sized map is 480 tiles wide, 961 would be enough to cover the entire map in all situations.

 When a connection passes through a tile of the specified terrain, the area within radius +/- variance will be subject to @racket[replace-terrain] / @racket[default-terrain-replacement] and terrains will be replaced accordingly.

 This attribute can be used multiple times for different terrains.

 A radius of 0 will still replace a single-tile width path.

 Variance is randomly selected for each tile crossed.

 If variance is larger than radius, it can reduce the radius to a negative value, in which case no terrain will be replaced around these specific locations.

 Example: Connect players with a variable ragged-looking road, and with shallows that are slightly wider.
 @racketmod[
 aoe2-rms

 <CONNECTION-GENERATION>
 (create-connect-all-players-land
  (replace-terrain 'GRASS 'ROAD)
  (replace-terrain 'WATER 'SHALLOW)
  (terrain-size 'GRASS 1 1)
  (terrain-size 'WATER 3 1))
 ]
}

@defproc[(accumulate-connections) void?]{
 Sections: @racket[<CONNECTION-GENERATION>].

 Game versions: DE only

 Can be used to revert a DE-specific behavior change where all connections are based on the terrain prior to connection generation.Replacing terrain created by earlier connections becomes possible when this is used.

 Example: Create a wide gap through a forest and then run a road through the created gap.
 @racketmod[
 aoe2-rms

 <LAND-GENERATION>
 (base-terrain 'FOREST)
 (create-player-lands
  (terrain-type 'FOREST)
  (other-zone-avoidance-distance 10))

 <CONNECTION-GENERATION>
 (accumulate-connections)
 (create-connect-all-lands
  (replace-terrain 'FOREST 'LEAVES)
  (terrain-size 'FOREST 10 0))
 (create-connect-all-lands
  (replace-terrain 'LEAVES 'ROAD)
  (terrain-size 'LEAVES 1 0))
 ]
}

@defproc[(create-actor-area [x any/c] [y any/c] [id any/c] [radius any/c]) void?]{
 Sections: @racket[<OBJECTS-GENERATION>]

 Game versions: DE only

 See also: @racket[actor-area].

 Arguments:
 @itemlist[
 @item{X - number (x-coordinate in tiles; see @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.qannz915qgy5"]{Map Sizes})}
 @item{Y - number (y-coordinate in tiles; see @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.qannz915qgy5"]{Map Sizes})}
 @item{Identifier - number}
 @item{Radius - number (square radius in tiles)}
 ]

 Create an actor area at the given location (rather than being associated with a specific object), with the ID and radius specified.

 @itemlist[
 @item{These actor areas are created before any @racket[create-object] commands are handled, regardless of their position in the script.}

 @item{Useful for making certain objects avoid certain positions or areas of the map.}

 @item{You can also specify coordinates outside of the map, which can be useful with a sufficiently large radius to avoid the map edges.}

 @item{Note that the X and Y coordinates are in tiles, NOT % of map width. They must be manually scaled to map size. See Map Sizes for the side length on each map size.}

 @item{Multiple actor areas can share the same identifier.}
 ]

 BUG: @racket[create-actor-area] will crash the game if no lands are generated on the map. This should not be an issue on completed maps, since you always have lands.


 Example: Create an actor area that prevents relics from spawning near the center of the map.
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (%cond ['TINY_MAP (create-actor-area 60 60 1234 30)]
        ['SMALL_MAP (create-actor-area 72 72 1234 36)]
        ['MEDIUM_MAP (create-actor-area 84 84 1234 42)]
        ['LARGE_MAP (create-actor-area 100 100 1234 50)]
        ['HUGE_MAP (create-actor-area 110 110 1234 55)]
        ['GIGANTIC_MAP (create-actor-area 120 120 1234 60)]
        ['LUDIKRIS_MAP (create-actor-area 240 240 1234 120)])

 (create-object 'RELIC
                (number-of-objects 500)
                (set-gaia-object-only)
                (avoid-actor-area 1234))
 ]
}

@defproc[(add-object [object-type any/c] [percentage any/c]) void?]{
 Blocks: @racket[create-object-group].

 Game versions: DE only
 Arguments:
 @itemlist[
 @item{ObjectType - object constant (see: @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.nvxriamulybh"]{Objects})}
 @item{% - number (0-99)}
 ]

 Adds an object into group.

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

@defproc[(number-of-objects [amount any/c]) void?]{
 Blocks: @racket[create-object].

 Game versions: All

 Arguments:
 amount - number (default: 1)

 Specifies the number of objects to create.

 A maximum of 9320 should be used when also specifying @racket[set-scaling-to-map-size].

 Example: Place 10 individual gold mines on the map.
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (create-object 'GOLD (number-of-objects 10))
 ]
}

@defproc[(number-of-groups [amount any/c]) void?]{
 Blocks: @racket[create-object].

 Game versions: All

 Arguments:
 amount - number (default: individual objects — no groups)

 Places the specified number of groups, each consisting of the number of individual objects specified in @racket[number-of-objects].

 @bold{Note:}
 Total objects = @racket[number-of-objects] × @racket[number-of-groups]
 A maximum of 9320 should be used when also specifying @racket[set-scaling-to-map-size].

 Example: Place 20 groups of 5 boars each.
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (create-object 'BOAR
                (number-of-objects 5)
                (number-of-groups 20))
 ]
}

@defproc[(group-variance [amount any/c]) void?]{
 Blocks: @racket[create-object].

 Game versions: All

 Arguments:
 amount - number (default: 0)

 Randomly varies the @racket[number-of-objects] for each group by up to the specified amount.

 The maximum positive variance is reduced by 1.

 @bold{Note:}
 A minimum of 1 object is always created, even if the variance would make the count 0 or negative.
 Each group varies independently — so this is not suitable for ensuring balanced player resources. Use @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.87mv66lnefdm"]{Random Code} for fairness instead.

 Example: Create 10 patches with each 2-7 forage bushes.
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (create-object 'FORAGE
                (number-of-objects 5)
                (number-of-groups 10)
                (group-variance 3)
                (set-tight-grouping))
 ]
}

@defproc[(group-placement-radius [radius any/c]) void?]{
 Blocks: @racket[create-object].

 Game versions: All

 Arguments:
 radius - number (default: 3 = a 7x7 area)

 Specifies how far (in tiles) objects in the same group may spawn from the central tile.
 This activates grouping behavior.

 @bold{Uses:}
 @itemlist[
 @item{Prevents grouped resources like gold, stone, or berries from forming long lines.}
 @item{If @racket[number-of-objects] exceeds available tiles, a perfect square will be filled.}
 @item{If combined with @racket[set-loose-grouping] and @racket[set-circular-placement], the group area will be circular instead of square.}
 ]

 Example: Give each player forage bushes that must stay in a 3x3 area.
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (create-object 'FORAGE
                (number-of-objects 7)
                (set-tight-grouping)
                (group-placement-radius 1)
                (set-gaia-object-only)
                (set-place-for-every-player)
                (min-distance-to-players 7)
                (max-distance-to-players 8))
 ]
}

@defproc[(set-tight-grouping) void?]{
 Blocks: @racket[create-object].

 Game versions: All

 Mutually exclusive with: @racket[set-loose-grouping]

 Forces objects in the same group to be placed on adjacent tiles.
 Commonly used for tightly grouped resources like berries, gold, or stone.

 Activates grouping behavior.

 @bold{Notes:}
 @itemlist[
 @item{Objects larger than one tile and that cannot overlap (e.g., buildings) will not be placed with tight grouping.}
 @item{Most placement constraints (@racket[avoid-forest-zone], @racket[min-distance-to-map-edge], @racket[min-distance-group-placement], @racket[avoid-actor-area]) apply only to the group’s center, not to individual objects.}
 @item{Use @racket[set-loose-grouping] instead if you want constraints to apply to each group member.}
 ]

 Example: Far player stone.
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (create-object 'STONE
                (number-of-objects 4)
                (group-placement-radius 2)
                (set-tight-grouping)
                (set-gaia-object-only)
                (set-place-for-every-player)
                (min-distance-to-players 20)
                (max-distance-to-players 27))
 ]
}

@defproc[(set-loose-grouping) void?]{
 Blocks: @racket[create-object].

 Game versions: All

 Mutually exclusive with: @racket[set-tight-grouping]

 Allows objects in the same group to be placed freely within the area defined by @racket[group-placement-radius].
 Activates grouping behavior.

 Loose grouping is the default, so you can omit this attribute if you specify @racket[group-placement-radius].
 Commonly used for scattered objects like sheep or deer.

 When combined with @racket[set-circular-placement], the placement area becomes circular instead of square.

 @bold{Notes:}
 @itemlist[
 @item{Most placement constraints (@racket[avoid-forest-zone], @racket[min-distance-to-map-edge], @racket[min-distance-group-placement], @racket[avoid-actor-area]) apply to each group member individually.}
 @item{The game does not check if there is enough room for the whole group when picking a location, so some objects may fail to spawn.}
 @item{For important resources or objects with many placement constraints, use @racket[set-tight-grouping] instead.}
 ]

 Example: Give players a group of 7 deer.
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (create-object 'DEER
                (number-of-objects 7)
                (number-of-groups 1)
                (group-placement-radius 5)
                (set-loose-grouping)
                (set-gaia-object-only)
                (set-place-for-every-player)
                (min-distance-to-players 14)
                (max-distance-to-players 22))
 ]
}

@defproc[(min-connected-tiles [amount any/c]) void?]{
 Blocks: @racket[create-object].

 Game versions: DE only

 Arguments:
 amount -  number (default: 0)

 Requires: objects must be placed in groups

 Prevents grouped objects from being placed in an area with fewer tiles than the specified amount.
 Intended to keep objects off tiny islands or out of small forest clearings.

 @bold{BUG:} Objects become heavily biased towards spawning in the top-left corner of the map, making this attribute unreliable for its intended purpose. Use @racket[max-distance-to-other-zones] or @racket[avoid-forest-zone] instead.

 Example: Create many groups of sheep that avoid small forest clearings and only appear in the top half of the map.
 @racketmod[
 aoe2-rms

 <LAND-GENERATION>
 (base-terrain 'BAMBOO)
 (create-player-lands
  (land-percent 50)
  (border-fuzziness 1)
  (left-border 25)
  (right-border 25)
  (top-border 25)
  (bottom-border 25)
  (zone 1))

 <OBJECTS-GENERATION>
 (create-object 'SHEEP
                (number-of-objects 4)
                (number-of-groups 150)
                (set-tight-grouping)
                (min-connected-tiles 80))
 ]
}

@defproc[(resource-delta [amount any/c]) void?]{
 Blocks: @racket[create-object].

 Game versions: UP/DE

 Arguments:
 amount -  number (default: 0)

 Modify the amount of food, wood, gold, or stone in an object.
 Negative values can be used to reduce the resources.

 @bold{Notes:}
 @itemlist[
 @item{Does not work for farms.}
 @item{Does not appear when testing a map from the scenario editor.}
 @item{You can give food to wolves. However, if a villager kills a wolf, they will automatically gather the food instead of performing the assigned task, which can affect gameplay.}
 ]

 @bold{Overflow behavior:}
 @itemlist[
 @item{In UP, resource amount will overflow past 32767.}
 @item{In DE, resource amount will overflow past 2147483647 (but will become inaccurate before then).}
 ]

 Example: Create gold piles that have 100 less gold in them and stone mines with 100 more stone.
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (create-object 'GOLD
                (number-of-objects 7)
                (resource-delta -100))
 (create-object 'STONE
                (number-of-objects 7)
                (resource-delta 100))
 ]
}

@defproc[(second-object [object-type any/c]) void?]{
 Blocks: @racket[create-object].

 Game versions: DE only

 Arguments:
 object-type - object constant (see: @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.nvxriamulybh"]{objects})

 Specify ANY object to be placed on top of the main object.
 If you place multiple objects, each will get the specified second object.

 @bold{Usage notes:}
 @itemlist[
 @item{In official maps, villagers were placed on top of farms for empire wars using this.}
 @item{Can bypass terrain restrictions by using an invisible placeholder object as the main object.}
 @item{For off-grid placeholders, any dead unit can be used, especially dead heroes without graphics in DE (e.g., ID 647).}
 @item{For on-grid placeholders, try terrain blocker (ID 1613), dead fish trap (ID 278), or a berry bush with zero food (using @racket[resource-delta]).}
 @item{Avoid using object 1291, as it now permanently converts player sheep to gaia in recent updates.}
 @item{Alternatively, terrain restrictions can be changed with @racket[effect-amount] or removed entirely with @racket[ignore-terrain-restrictions].}
 ]

 Example: Players start with a cow underneath their town center.
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (create-object 'TOWN_CENTER
                (set-place-for-every-player)
                (max-distance-to-players 0)
                (second-object 'DLC_COW))
 ]
}

@defproc[(set-scaling-to-map-size) void?]{
 Blocks: @racket[create-object].

 Game versions: All

 Mutually exclusive with: @racket[set-scaling-to-player-number]

 Scales @racket[number-of-groups] to the map size.
 The unscaled value refers to a 100x100 map (see: @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.qannz915qgy5"]{Map Sizes} for the scaling table).

 If no grouping is present, scaling applies to @racket[number-of-objects] instead.

 Example: Create clumps of 10 gold and scale the number of groups to map size.
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (create-object 'GOLD
                (number-of-objects 10)
                (number-of-groups 3)
                (set-scaling-to-map-size)
                (set-tight-grouping))
 ]
}

@defproc[(set-scaling-to-player-number) void?]{
 Blocks: @racket[create-object].

 Game versions: All

 Mutually exclusive with: @racket[set-scaling-to-map-size]

 Scales @racket[number-of-groups] based on the player count.
 For example, scales by 2x for a 2-player game, and 8x for an 8-player game.

 If no grouping is present, scaling applies to @racket[number-of-objects] instead.

 Example: Scale the number of relics by the number of players
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (create-object 'RELIC
                (number-of-objects 2)
                (set-scaling-to-player-number))
 ]
}

@defproc[(set-place-for-every-player) void?]{
 Blocks: @racket[create-object].

 Game versions: All

 Mutually exclusive with: @racket[place-on-specific-land-id]

 Places the object(s) as a personal object for each player land. Objects that cannot be owned by players (e.g., boar, gold, trees) also require @racket[set-gaia-object-only] to be placed for every player.

 @itemlist[
 @item{Only works for player lands or lands assigned to players; disabled if @racket[land-id] is specified.}
 @item{Objects will only be placed where they are not separated from their land origin by a terrain they are restricted on, unless @racket[ignore-terrain-restrictions] is used.
   @itemlist[
 @item{This means resources on islands will only appear on the player’s own island.}
 @item{Player gold mines on acropolis can only be placed on hilltops due to gold’s terrain restrictions.}
 @item{Water objects (docks/boats) can be placed if the player land is made of a dirt terrain type.}
 @item{Terrain restrictions can be bypassed by using placeholders with @racket[second-object], modified with @racket[effect-amount], or removed with @racket[ignore-terrain-restrictions].}
 @item{Road terrains, although restricted for resources, do not create separation like other terrains do.}
 @item{If @racket[avoid-other-land-zones] is specified, the object will only be placed on tiles belonging to that land.}
 ]}
 ]

 Example: Give every player their starting villagers.
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (create-object 'VILLAGER
                (set-place-for-every-player)
                (min-distance-to-players 6)
                (max-distance-to-players 7))
 ]
}

@defproc[(place-on-specific-land-id [id any/c]) void?]{
 Blocks: @racket[create-object].

 Game versions: All

 Mutually exclusive with: @racket[set-place-for-every-player]

 Arguments:
 id - number

 Places the object(s) on each land with the specified identifier.
 Land IDs are assigned in @racket[<LAND-GENERATION>] using the @racket[land-id] attribute.

 @itemlist[
 @item{Objects will only be placed where they are not separated from the origin of their land by a terrain they are restricted on, unless @racket[ignore-terrain-restrictions] is used.}
 @item{Road terrains, although restricted for resources, do not create separation like other terrains do.}
 @item{If @racket[avoid-other-land-zones] is specified, the object will only be placed on tiles belonging to that land.}
 @item{If multiple lands share the same ID, the object(s) will be placed on all of those lands.}
 ]

 Example: Create a tiny snowy land and place a gold mine on it.
 @racketmod[
 aoe2-rms

 <LAND-GENERATION>
 (base-terrain 'WATER)
 (create-player-lands
  (terrain-type 'DIRT)
  (land-percent 0))

 (create-land
  (terrain-type 'SNOW)
  (land-percent 0)
  (land-id 13)
  (land-position 50 50))

 <OBJECTS-GENERATION>
 (create-object 'GOLD
                (place-on-specific-land-id 13)
                (find-closest))
 ]
}

@defproc[(avoid-other-land-zones [distance any/c]) void?]{
 Blocks: @racket[create-object].

 Game versions: DE only

 Requires: @racket[set-place-for-every-player] or @racket[place-on-specific-land-id]

 Arguments:
 distance - number (default: no avoidance)

 Ensures that an object is placed only on tiles belonging to the land it is associated with,
 avoiding the edges of that land by the specified distance.

 @itemlist[
 @item{If this attribute is NOT specified, objects may be placed outside their referenced land.}
 @item{Even if 0 or a negative value is specified, objects will still be confined to the land.}
 @item{Do not use this attribute if you want objects to be placed beyond the land borders.}
 ]

 Example: Place gold on a specific desert land, while preventing it from being close to the edges of the land.
 @racketmod[
 aoe2-rms

 <LAND-GENERATION>
 (create-land
  (terrain-type 'DESERT)
  (land-percent 10)
  (land-id 1))

 <OBJECTS-GENERATION>
 (create-object 'GOLD
                (place-on-specific-land-id 1)
                (set-gaia-object-only)
                (number-of-objects 999)
                (avoid-other-land-zones 4))
 ]
}

@defproc[(generate-for-first-land-only) void?]{
 Blocks: @racket[create-object].

 Game versions: DE only

 Requires: @racket[set-place-for-every-player] or @racket[place-on-specific-land-id]

 When multiple @racket[create-player-lands] commands exist or multiple lands share the same land-id,
 this attribute restricts the object placement to only the first applicable land instead of all relevant lands.

 Example: Generate two lands for each player and give each player a house on both of them but a king only on one of them.
 @racketmod[
 aoe2-rms
 <LAND-GENERATION>
 (base-terrain 'WATER)
 (create-player-lands (land-percent 10))
 (create-player-lands (land-percent 10))
 <OBJECTS-GENERATION>
 (create-object 'HOUSE (set-place-for-every-player))
 (create-object 'KING
                (set-place-for-every-player)
                (generate-for-first-land-only))
 ]
}

@defproc[(set-gaia-object-only) void?]{
 Blocks: @racket[create-object].

 Game versions: All

 Use together with @racket[set-place-for-every-player] to place gaia (neutral) objects individually for each player.
 Required when placing player resources like gold, stone, berries, deer, or boar.

 Can also be used for controllable objects (e.g., sheep).

 Units and buildings will permanently join the player who first discovers them,
 unless @racket[set-gaia-unconvertible] is also specified.

 Gaia building architectural style can be changed with @racket[set-gaia-civilization].

 Example: Give every player four gaia sheep close to their starting town.
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (create-object 'SHEEP
                (number-of-objects 4)
                (set-loose-grouping)
                (set-gaia-object-only)
                (set-place-for-every-player)
                (min-distance-to-players 7)
                (max-distance-to-players 8))
 ]
}

@defproc[(set-gaia-unconvertible) void?]{
 Blocks: @racket[create-object].

 Game versions: DE only

 Requires: @racket[set-gaia-object-only]

 Mutually exclusive with: @racket[set-building-captureable]

 Use with any gaia object to make it unrescuable by players and hostile towards them.
 Must be specified after @racket[set-gaia-object-only].

 @itemlist[
 @item{Gaia military units behave as if on defensive stance—attacking anything entering their search radius and retreating if you run away.}
 @item{Does not work when testing from the scenario editor.}
 @item{Unrescuable status does not apply to @racket[second-object].}
 @item{Certain objects are always convertible (e.g., monuments) or buggy (e.g., town centers, gates).}
 @item{Gaia markets lose functionality and cannot be traded with. Use object 1646 for an indestructible market to trade with players.}
 @item{Villagers will repair gaia buildings instead of attacking them.}
 ]

 Example: Decorate the map with unrescuable gaia pyramids.
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (create-object 'PYRAMID
                (number-of-objects 3)
                (set-gaia-object-only)
                (set-gaia-unconvertible)
                (make-indestructible))
 ]
}

@defproc[(set-building-capturable) void?]{
 Blocks: @racket[create-object].

 Game versions: DE only

 Mutually exclusive with: @racket[set-gaia-unconvertible]

 Used to make a building switch control to the player who most recently has units nearby.
 Has no effect on units or other non-building objects.

 Can be applied to buildings starting under gaia or player control.

 @itemlist[
 @item{Capturable buildings cannot be deleted.}
 @item{Capturable buildings can be destroyed unless @racket[make-indestructible] is used.}
 ]

 Example: Place an outpost on the map that will convert to the control of whoever is currently nearby.
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (create-object 'OUTPOST
                (set-gaia-object-only)
                (make-indestructible)
                (set-building-capturable))
 ]
}

@defproc[(make-indestructible) void?]{
 Blocks: @racket[create-object].

 Game versions: DE only

 Makes a building indestructible by granting it 9999 HP and 1000/1000 armor.
 The building cannot be attacked, damaged, or deleted.

 Has no effect on units or other non-building objects.

 Can be used to create neutral gaia markets, docks, or entire cities that are invulnerable.

 Example: Make the starting town center indestructible.  (Note that this will mean that players cannot be defeated)
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (create-object 'TOWN_CENTER
                (set-place-for-every-player)
                (max-distance-to-players 0)
                (make-indestructible))
 ]
}

@defproc*[([(min-distance-to-players [distance any/c]) void?]
           [(max-distance-to-players [distance any/c]) void?])]{
 Blocks: @racket[create-object].

 Game versions: All

 Arguments:

 distance - number (default: no limits)

 Specifies the minimum distance (in tiles) from the origin of player lands at which the object or group center can be placed.

 @itemlist[
 @item{Distances define a square area, not a circle, unless @racket[set-circular-placement] is used.}
 @item{For grouped objects, distance applies to the group's center, not individual members.}
 @item{When used with @racket[place-on-specific-land-id], distances refer to that land specifically.}
 @item{When used without @racket[set-place-for-every-player] or @racket[place-on-specific-land-id], maximum distance has no effect.}
 @item{@bold{BUG (DE):} Minimum distance applies to all lands, not just player lands or specified land IDs. To work around this, use an @racket[actor-area] to control placement.}
 @item{@bold{BUG:} When minimum equals maximum distance, objects tend to be biased toward western placement.}
 @item{@bold{BUG (pre-DE):} Minimum distance always applies to all lands.}
 ]

 Example: Place the starting scout at a distance of 7-9 tiles.
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (create-object 'SCOUT
                (set-place-for-every-player)
                (min-distance-to-players 7)
                (max-distance-to-players 9))
 ]
}

@defproc[(set-circular-placement) void?]{
 Blocks: @racket[create-object].

 Game versions: DE only

 Changes the behavior of @racket[min-distance-to-players] and @racket[max-distance-to-players] to use circular (Euclidean) distance instead of a square radius.

 This prevents resources placed diagonally from being disproportionately far away compared to orthogonal placements.

 Recommended for most player object placements to improve resource distribution, unless map features like walls (which use square logic) are involved.

 Additionally, when used with groups that have @racket[set-loose-grouping], the group placement radius defined by @racket[group-placement-radius] will become circular instead of square.
}

@defproc[(terrain-to-place-on [type any/c]) void?]{
 Blocks: @racket[create-object].

 Game versions: All

 Arguments:
 type - terrain constant (see: @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.3bdjnf7tryyk"]{Terrains}) (default: any valid terrain)

 Restricts the placement of the object(s) to only the specified terrain type.
}

@defproc[(layer-to-place-on [type any/c]) void?]{
 Blocks: @racket[create-object].

 Game versions: DE only

 Arguments:
 type - terrain constant (see: @hyperlink["https://docs.google.com/document/d/1jnhZXoeL9mkRUJxcGlKnO98fIwFKStP_OBozpr0CHXo/edit?tab=t.0#heading=h.3bdjnf7tryyk"]{Terrains}) (default: any layer)

 Restricts the placement of the object(s) to only the specified layering terrain.

 @itemlist[
 @item{Works with @racket[terrain-mask] 1, but not with @racket[terrain-mask] 2. For @racket[terrain-mask] 2, use @racket[terrain-to-place-on] instead, since the layer becomes the main terrain.}
 @item{When used together with @racket[terrain-to-place-on], objects will be placed only where both the base terrain and the layer apply.}
 ]

 Example: Place rocks on a small patch of layered snow within a larger desert area.
 @racketmod[
 aoe2-rms

 <LAND-GENERATION>
 (create-land
  (terrain-type 'DESERT)
  (number-of-tiles 500)
  (land-position 50 50))

 <TERRAIN-GENERATION>
 (create-terrain 'SNOW
                 (base-terrain 'DESERT)
                 (number-of-tiles 20)
                 (terrain-mask 1))

 <OBJECTS-GENERATION>
 (create-object 'ROCK
                (number-of-objects 300)
                (layer-to-place-on 'DESERT))
 ]
}

@defproc[(ignore-terrain-restrictions) void?]{
 Blocks: @racket[create-object].

 Game versions: DE only

 Requires: @racket[set-place-for-every-player] or @racket[place-on-specific-land-id]

 Allows objects to be placed on terrains they are normally restricted from.
 These terrains will no longer act as borders preventing placement.
 Must be used in conjunction with @racket[set-place-for-every-player] or @racket[place-on-specific-land-id].

 @itemlist[
 @item{Can be combined with @racket[terrain-to-place-on]}
 @item{Alternatively, terrain restrictions can be modified using @racket[effect-amount] on ATTR_TERRAIN_ID, or by using @racket[second-object] with a placeholder.}
 ]

 Example: Place salmon on the land near each player's town center.  (Fish are can normally only be placed on water terrains)
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (create-object 'SALMON
                (number-of-objects 4)
                (set-place-for-every-player)
                (min-distance-to-players 3)
                (set-gaia-object-only)
                (find-closest)
                (ignore-terrain-restrictions))
 ]
}

@defproc[(max-distance-to-other-zones [distance any/c]) void?]{
 Blocks: @racket[create-object].

 Game versions: All

 Arguments:
 distance - number (default: 0)

 Specifies the minimum distance, in tiles, that objects will maintain from terrains they are restricted from being placed on.
 Useful for keeping resources away from coastlines or preventing deep fish from spawning near beaches.

 @itemlist[
 @item{For grouped objects, distance is measured from the center of the group, not individual members.}
 @item{Does not apply to road terrains, even though resources cannot be placed on them.}
 @item{Has no effect on objects without terrain restrictions.}
 ]

 Example: Place a central lake and then fill the map with gold that avoids being close to water.
 @racketmod[
 aoe2-rms

 <LAND-GENERATION>
 (create-land
  (terrain-type 'WATER)
  (number-of-tiles 500)
  (land-position 50 50))

 <OBJECTS-GENERATION>
 (create-object 'GOLD
                (number-of-groups 9000)
                (set-gaia-object-only)
                (max-distance-to-other-zones 5))
 ]
}

@defproc[(place-on-forest-zone) void?]{
 Blocks: @racket[create-object].

 Game versions: DE only

 Mutually exclusive with: @racket[avoid-forest-zone]

 Place objects only on tiles with trees or directly adjacent to such tiles.
 This includes straggler trees and trees placed via the scenario editor.

 Example: Place sheep all along the edge of forests.
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (create-object 'SHEEP
                (number-of-objects 99999)
                (place-on-forest-zone))
 ]
}

@defproc[(avoid-forest-zone [distance any/c]) void?]{
 Blocks: @racket[create-object].

 Game versions: DE only

 Mutually exclusive with: @racket[place-on-forest-zone]

 Arguments:
 distance - number (default: no avoidance; defaults to 1 if specified without a value)

 Objects will stay the specified number of tiles away from any trees, including straggler trees and scenario editor trees.
 Commonly used to keep resources away from forests.

 @itemlist[
 @item{The forest trees themselves are avoided, so for sparse forests (e.g., baobab), larger distances may be necessary.}
 @item{If the objects are grouped, the distance applies to each individual group member.}
 ]

 Example: Fill the map with gold, except for the areas near trees.
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (create-object 'GOLD
                (number-of-objects 9999)
                (avoid-forest-zone 3))
 ]
}

@defproc[(avoid-cliff-zone [distance any/c]) void?]{
 Blocks: @racket[create-object].

 Game versions: DE only

 Arguments:
 distance - number (default: no avoidance; defaults to 1 if specified without a value)

 Objects will stay the specified number of tiles away from cliffs.
 Due to the size of cliff objects, a distance of at least 2 is recommended to ensure a gap between cliffs and the objects.

 Useful for preventing inaccessible resources.

 If the objects are grouped, the distance applies to each individual group member.

 Example:  Fill the map with stone that stays 3 tiles away from cliffs.
 @racketmod[
 aoe2-rms

 <CLIFF-GENERATION>
 <OBJECTS-GENERATION>
 (create-object 'STONE
                (number-of-objects 9999)
                (avoid-cliff-zone 4))
 ]
}

@defproc[(min-distance-to-map-edge [distance any/c]) void?]{
 Blocks: @racket[create-object].

 Game versions: DE only

 Arguments:
 distance - number (default: 0)

 Minimum distance, in tiles, that objects will stay away from the edge of the map.

 If the objects are grouped, the distance refers to the center of the group, not the individual group members.

 Example: Ensure that relics stay at least 10 tiles from the edge of the map.
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (create-object 'RELIC
                (set-gaia-object-only)
                (number-of-objects 500)
                (min-distance-to-map-edge 10))
 ]
}


@defproc[(min-distance-group-placement [distance any/c]) void?]{
 Blocks: @racket[create-object].

 Game versions: All

 Arguments:
 distance - number (default: 0)

 Minimum distance, in tiles, that individual objects of the same create-object command, and all future objects, must stay away from each object.

 @itemlist[
 @item{Best used with small values to keep different resources from being directly next to each other.}
 @item{To scatter objects from the same command far away from each other, use @racket[temp-min-distance-group-placement].}
 @item{If the objects are grouped, the distance refers to the center of the group, not the individual members.}
 ]

 Example: Give each player two sets of forages and make them avoid each other by 4 tiles, and keep all future objects 4 tiles away.
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (create-object 'FORAGE
                (number-of-objects 7)
                (number-of-groups 2)
                (set-tight-grouping)
                (set-place-for-every-player)
                (set-gaia-object-only)
                (min-distance-to-players 8)
                (max-distance-to-players 10)
                (min-distance-group-placement 4))
 ]
}

@defproc[(temp-min-distance-group-placement [distance any/c]) void?]{
 Blocks: @racket[create-object].

 Game versions: All

 Arguments:
 distance - number (default: 0)

 Similar to @racket[min-distance-group-placement], but only applies to the current create-object command — future objects are unaffected.

 Useful for scattering objects, such as neutral resources and relics.

 Can be used together with @racket[min-distance-group-placement].

 If the objects are grouped, the distance refers to the center of the group, not the individual members.

 Example: Scatter neutral gold evenly across the map.
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (create-object 'GOLD
                (number-of-objects 9320)
                (number-of-groups 4)
                (set-gaia-object-only)
                (set-tight-grouping)
                (min-distance-group-placement 4)
                (temp-min-distance-group-placement 46))
 ]
}


@defproc[(find-closest) void?]{
 Blocks: @racket[create-object].

 Game versions: DE only

 Requires: @racket[set-place-for-every-player] or @racket[place-on-specific-land-id]

 Place the object on the closest free tile to the center of the land, considering all other constraints.

 @bold{Important:}

 @racket[find-closest] uses circular (Euclidean) distance, whereas other distance constraints (e.g., @racket[min-distance-to-players]) use square distance by default.

 Because of this, using both @racket[find-closest] and @racket[min-distance-to-players] (without additional constraints) may cause objects to be placed at right angles to each other, as the square's corners are farther from the center than its edges. Use @racket[set-circular-placement] combined with @racket[enable-tile-shuffling] to resolve this issue.

 @itemlist[
 @item{Previously, using @racket[find-closest] with reference to a land origin would place the object directly on the origin (if no other restrictions applied). But now, it places the object one tile away.}
 @item{Use @racket[max-distance-to-players 0] if you need the object placed exactly on the origin.}
 ]

 Example: Give each player a fishing ship on the closest free water tile
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (create-object 'FISHING_SHIP
                (set-place-for-every-player)
                (ignore-terrain-restrictions)
                (terrain-to-place-on 'WATER)
                (find-closest))
 ]
}

@defproc[(find-closest-to-map-center) void?]{
 Blocks: @racket[create-object].

 Game versions: DE only

 Requires: @racket[set-place-for-every-player] or @racket[place-on-specific-land-id]

 Place the object on the closest free tile to the center of the map, considering all other constraints.

 This attribute is overridden by @racket[find-closest].

 @bold{Bug:} When used with loosely grouped objects, some group members may fail to spawn if the closest free area is too small. @hyperlink["https://forums.ageofempires.com/t/usage-of-find-closest-and-set-loose-grouping-in-map-scripts/221258"]{Detailed bug description}.

 Example: Place a boar in the map center for each player.
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (create-object 'BOAR
                (set-place-for-every-player)
                (set-gaia-object-only)
                (find-closest-to-map-center))
 ]
}

@defproc[(find-closest-to-map-edge) void?]{
 Blocks: @racket[create-object].

 Game versions: DE only

 Requires: @racket[set-place-for-every-player] or @racket[place-on-specific-land-id]

 Place the object on the closest free tile to the edge of the map, considering all other constraints.

 This attribute is overridden by @racket[find-closest] and @racket[find-closest-to-map-center].

 @bold{Bug:} When used with loosely grouped objects, some group members may fail to spawn if the closest free area is too small. @hyperlink["https://forums.ageofempires.com/t/usage-of-find-closest-and-set-loose-grouping-in-map-scripts/221258"]{Detailed bug description}.

 Example: Place a relic on the map edge for each player.
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (create-object 'RELIC
                (set-place-for-every-player)
                (set-gaia-object-only)
                (find-closest-to-map-edge))
 ]
}

@defproc[(require-path [deviation any/c]) void?]{
 Blocks: @racket[create-object].

 Game versions: DE only

 Requires: @racket[set-place-for-every-player] or @racket[place-on-specific-land-id]

 Arguments:
 deviation - number (default: 0)
 @itemlist[
 @item{0 - indirect paths allowed; no additional restrictions beyond preventing completely inaccessible locations.}
 @item{1 - only mostly direct paths allowed to the origin.}
 @item{>1 - allows more deviation from the direct path; maximum effective value depends on path constriction.}
 ]

 Objects with this attribute must have a path to the origin of their associated land.  Use this attribute to prevent player resources from being trapped in or behind forests.
 @itemlist[
 @item{No argument, or a value of 0 imposes no further restrictions beyond preventing a completely inaccessible location.}
 @item{An argument of 1 means that the object must additionally have a mostly direct path to the origin.}
 @item{Larger values allow paths that are less direct. Maximum effective value depends on how constricted the path is.}
 @item{Walls (and gates) count as obstructing a path, so this attribute should not be used for objects outside of a player's walls on walled maps.}
 ]

 Example: Make sure a player boar isn't located behind nearby woodlines
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (create-object 'BOAR
                (set-place-for-every-player)
                (set-gaia-object-only)
                (require-path 1)
                (min-distance-to-players 16)
                (max-distance-to-players 22))
 ]
}

@defproc[(force-placement) void?]{
 Blocks: @racket[create-object].

 Game versions: DE only

 Allows multiple objects to be placed on the same tile if necessary.
 Normally, only one object per tile is placed; when tiles run out, no more objects are placed.
 With @racket[force-placement], remaining objects are placed on tile corners, then on top of each other.

 @itemlist[
 @item{Only works for objects that can overlap on the same tile (e.g., units, but not buildings).}
 @item{Disabled when using @racket[set-loose-grouping].}
 ]

 Example: Place 50 sheep in the 1-tile radius surrounding a starting outpost.
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (create-object 'OUTPOST
                (set-place-for-every-player)
                (max-distance-to-players 0))

 (create-object 'SHEEP
                (number-of-objects 50)
                (set-place-for-every-player)
                (max-distance-to-players 1)
                (force-placement))
 ]
}

@defproc[(actor-area [id any/c]) void?]{
 Blocks: @racket[create-object].

 Game versions: DE only

 See also: @racket[create-actor-area].

 Arguments:

 id - number (default: 0 - no actor area)

 Specifies a numerical identifier for an actor area.
 This identifier can be referenced in future objects with @racket[avoid-actor-area] or @racket[actor-area-to-place-in].

 Example: Spawn a wolf next to each relic.
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (create-object 'RELIC
                (number-of-objects 5)
                (set-gaia-object-only)
                (temp-min-distance-group-placement 35)
                (actor-area 1234))

 (create-object 'WOLF
                (number-of-objects 9320)
                (set-gaia-object-only)
                (actor-area-to-place-in 1234)
                (temp-min-distance-group-placement 25))
 ]
}

@defproc[(actor-area-radius [radius any/c]) void?]{
 Blocks: @racket[create-object].

 Game versions: DE only

 Requires: @racket[actor-area]

 Arguments:

 radius - number (default: 1 = 3x3 area)

 Specifies the size of the actor area when used with @racket[actor-area].
 If multiple objects share the same @racket[actor-area] value, they will all share the radius of the first object successfully created.

 Example: Give each player a mill with 7 deer in a 7-tile radius.
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (create-object 'MILL
                (set-place-for-every-player)
                (min-distance-to-players 16)
                (max-distance-to-players 20)
                (actor-area 61)
                (actor-area-radius 7))

 (create-object 'DEER
                (number-of-objects 7)
                (set-place-for-every-player)
                (set-gaia-object-only)
                (actor-area-to-place-in 61))
 ]
}

@defproc[(override-actor-radius-if-required) void?]{
 Blocks: @racket[create-object].

 Game versions: DE only

 Requires: @racket[actor-area-to-place-in]

 Prevents buildings from overlapping when placed inside an @racket[actor-area] with a radius too small to contain them, by expanding the valid placement area outward.

 Commonly used to ensure proper building placement (e.g., Empire Wars mills that become folwarks for Poles). Does not apply to units.

 Example: Place a barracks with the default actor_area_radius of 1, and then place a house adjacent, and prevent it from overlapping the barracks.
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (create-object 'BARRACKS
                (set-place-for-every-player)
                (find-closest)
                (actor-area 2))

 (create-object 'HOUSE
                (set-place-for-every-player)
                (actor-area-to-place-in 2)
                (override-actor-radius-if-required))
 ]
}

@defproc[(actor-area-to-place-in [id any/c]) void?]{
 Blocks: @racket[create-object].

 Game versions: DE only

 Arguments:
 id - number

 Place the object only within the radius of the specified @racket[actor-area] or @racket[create-actor-area].

 The same object can only have one @racket[actor-area-to-place-in].

 Actor areas have some intricacies that can affect placement. If you are having issues, follow these guidelines:

 @itemlist[
 @item{Different objects can be assigned to the same actor area.}
 @item{Do not place origin-referenced (either player or land id) objects in generic actor areas.}
 @item{Placing generic objects into land id-referenced actor areas always works.}
 @item{Placing generic objects into land id-referenced actor areas always works.}
 @item{Placing player objects into land id-referenced actor areas always works.}
 @item{Only player objects should be placed into player-referenced actor areas.}
 @item{When placing generic objects in generic actor areas, try to have the fewest @racket[create-object] commands possible between the actor area creation and the object to be placed in it.}
 @item{When none of the rules can be satisfied, inverse actor areas can be used as a failsafe.}
 ]

 Example: Place a lumber camp on the nearest forest and place villagers there too.
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (create-object 'LUMBER_CAMP
                (set-place-for-every-player)
                (max-distance-to-players 67)
                (place-on-forest-zone)
                (find-closest)
                (actor-area 8)
                (actor-area-radius 4))

 (create-object 'VILLAGER
                (set-place-for-every-player)
                (number-of-objects 4)
                (actor-area-to-place-in 8)
                (place-on-forest-zone)
                (find-closest))
 ]
}

@defproc[(avoid-actor-area [id any/c]) void?]{
 Blocks: @racket[create-object].

 Game versions: DE only

 Arguments:
 id - number

 The object will avoid the specified @racket[actor-area] or @racket[create-actor-area].
 The same object can avoid multiple actor areas.
 You can specify an @racket[actor-area] and then avoid that same actor area within the same @racket[create-object]. However, this only works with ungrouped objects, or those with @racket[set-loose-grouping].

 Example: Place a barracks for empire wars but have it avoid various other objects that you already placed.
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (create-object 'BARRACKS
                (set-place-for-every-player)
                (min-distance-to-players 7)
                (max-distance-to-players 9)
                (avoid-actor-area 94)
                (avoid-actor-area 40)
                (avoid-actor-area 8)
                (avoid-actor-area 9)
                (avoid-actor-area 99)
                (avoid-actor-area 171)
                (actor-area 51)
                (actor-area-radius 5))
 ]
}

@defproc[(avoid-all-actor-areas) void?]{
 Blocks: @racket[create-object].

 Game versions: DE only

 The object will avoid being placed within ANY existing @racket[actor-area] or @racket[create-actor-area]

 Example: Place wolves that avoid all actor areas.
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (create-object 'TOWN_CENTER
                (set-place-for-every-player)
                (max-distance-to-players 0)
                (actor-area 100)
                (actor-area-radius 60))
 (create-object 'WOLF
                (number-of-objects 9320)
                (temp-min-distance-group-placement 52)
                (avoid-all-actor-areas))
 ]
}

@defproc[(enable-tile-shuffling) void?]{
 Blocks: @racket[create-object].

 Game versions: DE only

 Increases randomness of object positions by shuffling the list of candidate tiles rather than just using the first entry.

 @itemlist[
 @item{When using both @racket[find-closest] and @racket[set-circular-placement], add this attribute to prevent objects from being in predictable positions.}
 @item{Does not prevent the bias towards the west when @racket[min-distance-to-players] and @racket[max-distance-to-players] are close or equal.}
 @item{Should NOT be used when attempting to place objects in a specific precise location (ie. placing herdables or villagers under the town center.)}
 ]

 Example:  Create 4 individual gold mines randomly positioned in a circle around players, with no bias towards any position.
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (create-object 'GOLD
                (set-place-for-every-player)
                (set-gaia-object-only)
                (number-of-objects 4)
                (min-distance-to-players 12)
                (set-circular-placement)
                (find-closest)
                (enable-tile-shuffling))
 ]
}

@defproc[(set-facet [facet-number any/c]) void?]{
 Blocks: @racket[create-land].

 Game versions: DE only

 Arguments:

 facet-number - number (default: 0 - random facet)
 FacetNumber corresponds to the index - 1 of the desired frame in the sprite.
 To get the first frame, pick a facet number below 0, or above the maximum for that object.

 Choose which frame (of the sprite) of an object to generate.
 @itemlist[
 @item{For units, this corresponds to the angle they are facing.}
 @item{For other objects, this may correspond to alternative appearances.
   Facets can be cycled by using the rotate feature in the scenario editor.}
 @item{Frames can be viewed using external tools such as SLX Studio.}
 ]

 Example: Generate 10 jungle straggler trees that all look identical and have the appearance of frame n_tree_jungle_x1_031 (a large and small palm tree)
 @racketmod[
 aoe2-rms

 <OBJECTS-GENERATION>
 (create-object 'JUNGLETREE
                (number-of-objects 10)
                (set-facet 30))
 ]
}
