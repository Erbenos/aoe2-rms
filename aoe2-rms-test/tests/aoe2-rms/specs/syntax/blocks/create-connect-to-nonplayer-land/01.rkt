#lang aoe2-rms
; Connect players to a central desert, but not directly to each other

<LAND-GENERATION>
(create-player-lands
 (terrain-type 'DIRT2)
 (number-of-tiles 100))

(create-land
 (terrain-type 'DESERT)
 (number-of-tiles 500)
 (land-position 50 50))

<CONNECTION-GENERATION>
(create-connect-to-nonplayer-land
 (replace-terrain 'GRASS 'ROAD2))
