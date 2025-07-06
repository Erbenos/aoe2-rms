#lang aoe2-rms
; All players are on the same continent, the rest of the map is water.

<LAND-GENERATION>
(base-terrain 'WATER)
(create-player-lands
 (terrain-type 'DIRT)
 (land-percent 60)
 (zone 1))
