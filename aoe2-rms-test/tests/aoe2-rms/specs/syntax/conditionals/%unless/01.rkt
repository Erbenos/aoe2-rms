#lang aoe2-rms
; Set up a NOT conditional - place a cow when "infinite resources" is not true.

<OBJECTS-GENERATION>
(%unless 'INFINITE_RESOURCES
         (create-object 'DLC_COW
                        (set-place-for-every-player)
                        (find-closest)))
