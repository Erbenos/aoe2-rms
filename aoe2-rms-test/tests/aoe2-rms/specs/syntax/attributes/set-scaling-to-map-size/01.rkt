#lang aoe2-rms
; Create clumps of 10 gold and scale the number of groups to map size.

<OBJECTS-GENERATION>
(create-object 'GOLD
               (number-of-objects 10)
               (number-of-groups 3)
               (set-scaling-to-map-size)
               (set-tight-grouping))
