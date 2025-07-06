#lang aoe2-rms
; Snow is masked underneath grass.  Would produce snow decoration objects, if there were any in the game.

<TERRAIN-GENERATION>
(create-terrain 'SNOW
                (base-terrain 'GRASS)
                (land-percent 50)
                (terrain-mask 2))
