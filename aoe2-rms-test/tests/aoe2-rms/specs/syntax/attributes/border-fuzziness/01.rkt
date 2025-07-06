#lang aoe2-rms
; Central desert with very fuzzy borders

<LAND-GENERATION>
(create-land
 (terrain-type 'DESERT)
 (land-position 50 50)
 (land-percent 100)
 (left-border 40)
 (right-border 40)
 (top-border 40)
 (bottom-border 40)
 (border-fuzziness 2))
