#lang aoe2-rms
; Connect players with a variable ragged-looking road, and with shallows that are slightly wider.

<CONNECTION-GENERATION>
(create-connect-all-players-land
 (replace-terrain 'GRASS 'ROAD)
 (replace-terrain 'WATER 'SHALLOW)
 (terrain-size 'GRASS 1 1)
 (terrain-size 'WATER 3 1))
