#lang aoe2-rms
; Place rocks on a small patch of layered snow within a larger desert area.

<LAND-GENERATION>
(create-land
 (terrain-type 'DESERT)
 (number-of-tiles 500)
 (land-position 50 50))

<TERRAIN-GENERATION>
(create-terrain 'SNOW
                (base-terrain 'DESERT)
                (number-of-tiles 20)
                (terrain-mask 1))

<OBJECTS-GENERATION>
(create-object 'ROCK
               (number-of-objects 300)
               (layer-to-place-on 'DESERT))
