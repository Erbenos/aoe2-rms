#lang aoe2-rms
; Define and use variable constants depending on the season.

(%random [30 (%define 'WINTER)]
         [30 (%define 'AUTUMN)])

(%cond ['WINTER
        (%const 'LAND_A 32)
        (%const 'BERRY_TYPE 52)]
       ['AUTUMN
        (%const 'LAND_A 5)
        (%const 'BERRY_TYPE 59)]
       [#f (%const 'LAND_A 3) (%const 'BERRY_TYPE 1059)])

<LAND-GENERATION>
(create-player-lands (terrain-type 'LAND_A))

<OBJECTS-GENERATION>
(create-object 'BERRY_TYPE
               (number-of-objects 5)
               (set-place-for-every-player)
               (set-gaia-object-only)
               (find-closest)
               (terrain-to-place-on 'LAND_A))
