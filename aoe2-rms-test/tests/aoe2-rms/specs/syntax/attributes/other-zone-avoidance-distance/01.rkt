#lang aoe2-rms
; A rivers map where all players are separated by water, and there is a neutral island in the center.

<LAND-GENERATION>
(base-terrain 'WATER)
(create-player-lands
 (terrain-type 'GRASS)
 (land-percent 100)
 (other-zone-avoidance-distance 10))

(create-land
 (terrain-type 'DIRT)
 (land-percent 100)
 (land-position 50 50)
 (zone 1)
 (other-zone-avoidance-distance 10))
