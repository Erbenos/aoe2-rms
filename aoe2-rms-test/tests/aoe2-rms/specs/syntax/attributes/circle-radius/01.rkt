#lang aoe2-rms
; Place player lands in a perfect circle close to the center of the map.

<LAND-GENERATION>
(create-player-lands
 (terrain-type 'DIRT)
 (number-of-tiles 100)
 (circle-radius 20 0))
