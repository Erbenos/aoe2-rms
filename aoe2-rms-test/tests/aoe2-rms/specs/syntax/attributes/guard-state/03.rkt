#lang aoe2-rms
; Enable a small, relic-style gold trickle and configure players to be defeated if all villagers are lost.

<PLAYER-SETUP>
(guard-state 'VILLAGER_CLASS 'AMOUNT_GOLD 10 3)
