#lang aoe2-rms
; Create one large large hill with increased spacing.

<ELEVATION-GENERATION>
(create-elevation 7
                  (base-terrain 'GRASS)
                  (number-of-tiles 3000)
                  (spacing 4))
