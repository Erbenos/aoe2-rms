#lang aoe2-rms
; Connect all players with dirt terrain

<LAND-GENERATION>
(create-player-lands
 (terrain-type 'DESERT)
 (number-of-tiles 100))

<CONNECTION-GENERATION>
(create-connect-all-players-land
 (default-terrain-replacement 'DIRT))
