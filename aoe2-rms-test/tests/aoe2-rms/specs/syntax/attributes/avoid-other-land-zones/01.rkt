#lang aoe2-rms
; Place gold on a specific desert land, while preventing it from being close to the edges of the land.

<LAND-GENERATION>
(create-land
 (terrain-type 'DESERT)
 (land-percent 10)
 (land-id 1))

<OBJECTS-GENERATION>
(create-object 'GOLD
               (place-on-specific-land-id 1)
               (set-gaia-object-only)
               (number-of-objects 999)
               (avoid-other-land-zones 4))
