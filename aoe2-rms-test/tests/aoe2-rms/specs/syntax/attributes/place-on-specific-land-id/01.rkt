#lang aoe2-rms
; Create a tiny snowy land and place a gold mine on it.

<LAND-GENERATION>
(base-terrain 'WATER)
(create-player-lands
 (terrain-type 'DIRT)
 (land-percent 0))

(create-land
 (terrain-type 'SNOW)
 (land-percent 0)
 (land-id 13)
 (land-position 50 50))

<OBJECTS-GENERATION>
(create-object 'GOLD
               (place-on-specific-land-id 13)
               (find-closest))
