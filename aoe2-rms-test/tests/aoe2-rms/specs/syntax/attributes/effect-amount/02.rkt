#lang aoe2-rms
; Houses support 10/15/20/25 population in dark/feudal/castle/imperial age.

<PLAYER-SETUP>
(effect-amount 'SET_ATTRIBUTE 'HOUSE 'ATTR_STORAGE_VALUE 10)
(effect-amount 'SET_ATTRIBUTE 'HOUSE_F 'ATTR_STORAGE_VALUE 15)
(effect-amount 'SET_ATTRIBUTE 'HOUSE_C 'ATTR_STORAGE_VALUE 20)
(effect-amount 'SET_ATTRIBUTE 'HOUSE_I 'ATTR_STORAGE_VALUE 25)
