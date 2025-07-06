#lang aoe2-rms
; Activate a guardstate on the king, to make a map regicide even in other game modes.

<PLAYER-SETUP>
(guard-state 'KING 'AMOUNT_GOLD 0 1)
