#lang aoe2-rms
; Make the starting town center indestructible.  (Note that this will mean that players cannot be defeated)

<OBJECTS-GENERATION>
(create-object 'TOWN_CENTER
               (set-place-for-every-player)
               (max-distance-to-players 0)
               (make-indestructible))
