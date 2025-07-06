#lang aoe2-rms
; Add 0.3 speed to all villagers (30/100 = 0.3)

<PLAYER-SETUP>
(effect-percent 'ADD_RESOURCE 'VILLAGER_CLASS 'ATTR_MOVE_SPEED 30)
