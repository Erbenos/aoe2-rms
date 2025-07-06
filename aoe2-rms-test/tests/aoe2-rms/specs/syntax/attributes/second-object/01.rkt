#lang aoe2-rms
; Players start with a cow underneath their town center.

<OBJECTS-GENERATION>
(create-object 'TOWN_CENTER
               (set-place-for-every-player)
               (max-distance-to-players 0)
               (second-object 'DLC_COW))
