#lang aoe2-rms
; Place 5 or 6 or 7 gold mines with 6 being the most likely.

<OBJECTS-GENERATION>
(create-object 'GOLD
               (%random [30 (number-of-objects 5)]
                        [50 (number-of-objects 6)]
                        [20 (number-of-objects 7)]))
