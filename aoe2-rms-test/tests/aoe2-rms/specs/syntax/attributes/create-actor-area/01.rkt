#lang aoe2-rms
; Create an actor area that prevents relics from spawning near the center of the map.

<OBJECTS-GENERATION>
(%cond ['TINY_MAP (create-actor-area 60 60 1234 30)]
       ['SMALL_MAP (create-actor-area 72 72 1234 36)]
       ['MEDIUM_MAP (create-actor-area 84 84 1234 42)]
       ['LARGE_MAP (create-actor-area 100 100 1234 50)]
       ['HUGE_MAP (create-actor-area 110 110 1234 55)]
       ['GIGANTIC_MAP (create-actor-area 120 120 1234 60)]
       ['LUDIKRIS_MAP (create-actor-area 240 240 1234 120)])

(create-object 'RELIC
               (number-of-objects 500)
               (set-gaia-object-only)
               (avoid-actor-area 1234))
