#lang aoe2-rms
; Create gold piles that have 100 less gold in them and stone mines with 100 more stone.

<OBJECTS-GENERATION>
(create-object 'GOLD
               (number-of-objects 7)
               (resource-delta -100))
(create-object 'STONE
               (number-of-objects 7)
               (resource-delta 100))
