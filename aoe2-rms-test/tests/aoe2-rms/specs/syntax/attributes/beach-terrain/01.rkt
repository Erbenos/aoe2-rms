#lang aoe2-rms
; Create a dirt island with beaches that have vegetation.

<LAND-GENERATION>
(base-terrain 'WATER)

<TERRAIN-GENERATION>
(create-terrain 'DIRT
                (number-of-tiles 500)
                (spacing-to-other-terrain-types 1)
                (base-terrain 'WATER)
                (beach-terrain 'DLC_BEACH2))
