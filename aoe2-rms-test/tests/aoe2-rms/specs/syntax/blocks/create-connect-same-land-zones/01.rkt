#lang aoe2-rms
; Connect a lake, forest and desert to each other

<LAND-GENERATION>
(create-land
 (terrain-type 'FOREST)
 (land-percent 5)
 (zone 1))
(create-land
 (terrain-type 'DESERT)
 (land-percent 5)
 (zone 1))
(create-land
 (terrain-type 'WATER)
 (land-percent 5)
 (zone 50))

<CONNECTION-GENERATION>
(create-connect-same-land-zones
 (default-terrain-replacement 'ICE))
