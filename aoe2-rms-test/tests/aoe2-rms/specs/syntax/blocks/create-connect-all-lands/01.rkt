#lang aoe2-rms
; Interconnect all player islands and neutral islands.

<LAND-GENERATION>
(base-terrain 'WATER)
(create-player-lands
 (terrain-type 'DESERT)
 (number-of-tiles 100))
(create-land
 (terrain-type 'FOREST)
 (number-of-tiles 100)
 (land-position 99 1))
(create-land
 (terrain-type 'PINE_FOREST)
 (number-of-tiles 100)
 (land-position 50 50))

<CONNECTION-GENERATION>
(create-connect-all-lands (replace-terrain 'WATER 'SHALLOW))
