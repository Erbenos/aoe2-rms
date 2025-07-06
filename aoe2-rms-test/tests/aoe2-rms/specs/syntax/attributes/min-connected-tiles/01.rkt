#lang aoe2-rms
; Create many groups of sheep that avoid small forest clearings and only appear in the top half of the map.

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
