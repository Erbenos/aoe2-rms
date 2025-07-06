#lang aoe2-rms
; Replace all connecting terrain with road, but replace water with shallows instead.

<LAND-GENERATION>
(base-terrain 'WATER)
(create-player-lands
 (land-percent 100)
 (other-zone-avoidance-distance 10))

<CONNECTION-GENERATION>
(create-connect-all-players-land
 (default-terrain-replacement 'ROAD)
 (replace-terrain 'WATER 'SHALLOW))
