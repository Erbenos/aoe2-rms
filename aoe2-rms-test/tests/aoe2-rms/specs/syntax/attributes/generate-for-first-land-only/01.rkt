#lang aoe2-rms
; Generate two lands for each player and give each player a house on both of them but a king only on one of them.

<LAND-GENERATION>
(base-terrain 'WATER)
(create-player-lands (land-percent 10))
(create-player-lands (land-percent 10))

<OBJECTS-GENERATION>
(create-object 'HOUSE (set-place-for-every-player))
(create-object 'KING
               (set-place-for-every-player)
               (generate-for-first-land-only))
