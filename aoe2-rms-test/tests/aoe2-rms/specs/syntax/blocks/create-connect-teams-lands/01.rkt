#lang aoe2-rms
; Connect team members with a road

<LAND-GENERATION>
(create-player-lands
 (terrain-type 'DESERT)
 (number-of-tiles 100))

<CONNECTION-GENERATION>
(create-connect-teams-lands
 (replace-terrain 'DESERT 'ROAD)
 (replace-terrain 'GRASS 'ROAD))
