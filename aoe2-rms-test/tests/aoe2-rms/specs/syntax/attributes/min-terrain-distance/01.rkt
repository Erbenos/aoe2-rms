#lang aoe2-rms
; Fill the map with cliffs that stay only 3 tiles from water and 0 tiles from each other.

<LAND-GENERATION>
(base-terrain 'WATER)
(create-player-lands
 (terrain-type 'GRASS)
 (land-percent 100)
 (other-zone-avoidance-distance 10))

<CLIFF-GENERATION>
(min-number-of-cliffs 9999)
(max-number-of-cliffs 9999)
(min-distance-cliffs 0)
(min-terrain-distance 1)
