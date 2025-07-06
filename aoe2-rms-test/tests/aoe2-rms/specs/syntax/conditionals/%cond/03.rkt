#lang aoe2-rms
; Set up a NOT conditional - place a cow when "infinite resources" is not true.

<OBJECTS-GENERATION>
(%cond ['INFINITE_RESOURCES]
       [#f (create-object 'DLC_COW
                          (set-place-for-every-player)
                          (find-closest))])
