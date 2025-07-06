#lang aoe2-rms
; Slowly drain a player's food while they do not control the monument.

<PLAYER-SETUP>
(guard-state 'MONUMENT 'AMOUNT_FOOD -5 6)
