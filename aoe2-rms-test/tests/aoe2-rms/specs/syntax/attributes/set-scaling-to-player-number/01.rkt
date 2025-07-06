#lang aoe2-rms
; Scale the number of relics by the number of players

<OBJECTS-GENERATION>
(create-object 'RELIC
               (number-of-objects 2)
               (set-scaling-to-player-number))
