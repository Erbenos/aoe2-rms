#lang aoe2-rms
; Manually scale relic count to map size.

<OBJECTS-GENERATION>
(create-object 'RELIC
               (min-distance-to-players 25)
               (%cond ['TINY_MAP
                       (number-of-objects 5)
                       (temp-min-distance-group-placement 35)]
                      ['SMALL_MAP
                       (number-of-objects 5)
                       (temp-min-distance-group-placement 38)]
                      ['MEDIUM_MAP
                       (number-of-objects 5)
                       (temp-min-distance-group-placement 38)]
                      ['LARGE_MAP
                       (number-of-objects 7)
                       (temp-min-distance-group-placement 48)]
                      ['HUGE_MAP
                       (number-of-objects 8)
                       (temp-min-distance-group-placement 52)]
                      [#f (number-of-objects 999) (temp-min-distance-group-placement 52)]))
