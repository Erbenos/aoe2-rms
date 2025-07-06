#lang aoe2-rms
; Create a pool of all cow variations and then generate clusters of mixed cow variants.

<OBJECTS-GENERATION>
(create-object-group 'HERDABLE_A
                     (add-object 'DLC_COW 25)
                     (add-object 'DLC_COW_B 25)
                     (add-object 'DLC_COW_C 25)
                     (add-object 'DLC_COW_D 25))
(create-object 'HERDABLE_A
               (number-of-objects 6)
               (number-of-groups 24))
