#lang aoe2-rms
; Replace several terrains in a connection

<CONNECTION-GENERATION>
(create-connect-all-players-land
 (replace-terrain 'GRASS 'ROAD)
 (replace-terrain 'FOREST 'LEAVES)
 (replace-terrain 'WATER 'SHALLOW)
 (replace-terrain 'MED_WATER 'SHALLOW)
 (replace-terrain 'DEEP_WATER 'SHALLOW)
 (terrain-cost 'GRASS 1)
 (terrain-cost 'FOREST 7)
 (terrain-cost 'WATER 7)
 (terrain-cost 'MED_WATER 12)
 (terrain-cost 'DEEP_WATER 15))
