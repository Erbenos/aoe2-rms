#lang aoe2-rms
; Check for various game versions.

<OBJECTS-GENERATION>
(%cond ['DE_AVAILABLE]
       ['DLC_TIGER (%cond ['UP_EXTENSION (%define 'WOLOLOKINGDOMS)]
                          [#f (%define 'HD_DLC)])]
       ['DLC_COW (%define 'HD_BASE)]
       ['UP_EXTENSION]
       ['UP_AVAILABLE]
       [#f (%define 'CONQUERORS_CD)])
