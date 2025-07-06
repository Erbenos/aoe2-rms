#lang aoe2-rms
; Generate 10 jungle straggler trees that all look identical and have the appearance of frame n_tree_jungle_x1_031 (a large and small palm tree)

<OBJECTS-GENERATION>
(create-object 'JUNGLETREE
               (number-of-objects 10)
               (set-facet 30))
