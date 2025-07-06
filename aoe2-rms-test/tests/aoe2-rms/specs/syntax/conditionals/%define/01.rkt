#lang aoe2-rms
; Set up seasonal variations for the base terrain.

(%random [20 (%define 'WINTER)]
         [20 (%define 'AUTUMN)])

<LAND-GENERATION>
(%cond ['WINTER (base-terrain 'SNOW)]
       ['AUTUMN (base-terrain 'LEAVES)]
       [#f (base-terrain 'DIRT)])
