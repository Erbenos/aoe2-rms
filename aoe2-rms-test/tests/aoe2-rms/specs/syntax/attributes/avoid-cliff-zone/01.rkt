#lang aoe2-rms
; Fill the map with stone that stays 3 tiles away from cliffs.

<CLIFF-GENERATION>
<OBJECTS-GENERATION>
(create-object 'STONE
               (number-of-objects 9999)
               (avoid-cliff-zone 4))
