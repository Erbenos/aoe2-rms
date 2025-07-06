#lang aoe2-rms
; Place sheep all along the edge of forests.

<OBJECTS-GENERATION>
(create-object 'SHEEP
               (number-of-objects 99999)
               (place-on-forest-zone))
