#lang aoe2-rms
; Give every player 300 tiles.

<LAND-GENERATION>
(create-player-lands
 (terrain-type 'DIRT)
 (number-of-tiles 300))
