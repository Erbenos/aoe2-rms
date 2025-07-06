#lang aoe2-rms
; Give every player four gaia sheep close to their starting town.

<OBJECTS-GENERATION>
(create-object 'SHEEP
               (number-of-objects 4)
               (set-loose-grouping)
               (set-gaia-object-only)
               (set-place-for-every-player)
               (min-distance-to-players 7)
               (max-distance-to-players 8))
