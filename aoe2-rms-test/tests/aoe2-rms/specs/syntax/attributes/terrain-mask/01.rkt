#lang aoe2-rms
; Snow is masked on top of grass.  Will produce grass decoration objects.

<TERRAIN-GENERATION>
(create-terrain 'SNOW
                (base-terrain 'GRASS)
                (land-percent 50)
                (terrain-mask 1))
