#lang aoe2-rms
; Create a wide gap through a forest and then run a road through the created gap.

<LAND-GENERATION>
(base-terrain 'FOREST)
(create-player-lands
 (terrain-type 'FOREST)
 (other-zone-avoidance-distance 10))

<CONNECTION-GENERATION>
(accumulate-connections)
(create-connect-all-lands
 (replace-terrain 'FOREST 'LEAVES)
 (terrain-size 'FOREST 10 0))
(create-connect-all-lands
 (replace-terrain 'LEAVES 'ROAD)
 (terrain-size 'LEAVES 1 0))
