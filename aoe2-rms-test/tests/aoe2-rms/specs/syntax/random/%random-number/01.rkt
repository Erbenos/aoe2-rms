#lang aoe2-rms
; Place 5 or 6 or 7 gold piles, and randomly change the amount of gold (it will be the same amount in all of them)

<OBJECTS-GENERATION>
(create-object 'GOLD
               (number-of-objects (%random-number 5 7))
               (resource-delta (%random-number -200 300)))
