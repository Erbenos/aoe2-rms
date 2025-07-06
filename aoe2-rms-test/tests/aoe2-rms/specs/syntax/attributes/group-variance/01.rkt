#lang aoe2-rms
; Create 10 patches with each 2-7 forage bushes.

<OBJECTS-GENERATION>
(create-object 'FORAGE
               (number-of-objects 5)
               (number-of-groups 10)
               (group-variance 3)
               (set-tight-grouping))
