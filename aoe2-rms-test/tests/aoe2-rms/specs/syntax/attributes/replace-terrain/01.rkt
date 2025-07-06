#lang aoe2-rms
; Replace several terrains in a connection

<CONNECTION-GENERATION>
(create-connect-all-players-land
 (replace-terrain 'GRASS 'DIRT2)
 (replace-terrain 'FOREST 'LEAVES)
 (replace-terrain 'SNOW_FOREST 'GRASS_SNOW)
 (replace-terrain 'DIRT 'DIRT3)
 (replace-terrain 'WATER 'SHALLOW))
