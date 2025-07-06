#lang aoe2-rms
; Fill the map with gold, except for the areas near trees.

<OBJECTS-GENERATION>
(create-object 'GOLD
               (number-of-objects 9999)
               (avoid-forest-zone 3))
