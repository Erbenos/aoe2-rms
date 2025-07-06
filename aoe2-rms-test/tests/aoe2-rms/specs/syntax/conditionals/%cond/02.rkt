#lang aoe2-rms
; Replace the scout with a king when playing regicide.

<OBJECTS-GENERATION>
(%cond ['REGICIDE (%const 'HERO 'KING)]
       [#f (%const 'HERO 'SCOUT)])

(create-object 'HERO
               (set-place-for-every-player)
               (min-distance-to-players 7)
               (max-distance-to-players 9))
