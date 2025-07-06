#lang aoe2-rms
; Create three deserts that have their origins at least 25 tiles from the other deserts.

<LAND-GENERATION>
(create-land
 (terrain-type 'DESERT)
 (land-percent 1)
 (min-placement-distance 25))

(create-land
 (terrain-type 'DESERT)
 (land-percent 1)
 (min-placement-distance 25))

(create-land
 (terrain-type 'DESERT)
 (land-percent 1)
 (min-placement-distance 25))
