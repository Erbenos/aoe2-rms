#lang aoe2-rms
; Assign a desert land to player 1.

 <LAND-GENERATION>
 (create-land
  (terrain-type 'DESERT)
  (land-percent 3)
  (assign-to-player 1))
