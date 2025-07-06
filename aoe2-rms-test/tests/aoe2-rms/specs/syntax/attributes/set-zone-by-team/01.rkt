#lang aoe2-rms
; Team Islands.

<LAND-GENERATION>
(base-terrain 'WATER)
(create-player-lands
 (terrain-type 'DIRT)
 (land-percent 80)
 (set-zone-by-team)
 (other-zone-avoidance-distance 10)
 (left-border 10)
 (top-border 10)
 (right-border 10)
 (bottom-border 10))
