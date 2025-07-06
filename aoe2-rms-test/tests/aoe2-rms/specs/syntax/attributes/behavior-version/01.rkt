#lang aoe2-rms
; Activate new land generation behavior in your script and observe that your lands get smaller.

(behavior-version 1)

<LAND-GENERATION>
(create-player-lands
 (terrain-type 'DLC_BLACK)
 (number-of-tiles 250)
 (base-size 12))
