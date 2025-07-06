#lang aoe2-rms
; Archipelago-styled map where players might be on the same island with allies, enemies or nobody.

<LAND-GENERATION>
(base-terrain 'WATER)
(create-player-lands
 (terrain-type 'DIRT)
 (land-percent 80)
 (set-zone-randomly)
 (other-zone-avoidance-distance 10)
 (left-border 10)
 (top-border 10)
 (right-border 10)
 (bottom-border 10))
