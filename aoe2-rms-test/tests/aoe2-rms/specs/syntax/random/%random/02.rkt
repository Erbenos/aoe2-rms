#lang aoe2-rms
; Have a 10% chance of placing 5 gold mines (and a 90% of not doing so)

<OBJECTS-GENERATION>
(%random [10 (create-object 'GOLD
                            (number-of-objects 5))])
