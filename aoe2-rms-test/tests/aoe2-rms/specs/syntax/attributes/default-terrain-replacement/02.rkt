#lang aoe2-rms
; Replace everything with ice to see which routes the connections are taking.

<CONNECTION-GENERATION>
(create-connect-all-lands
 (default-terrain-replacement 'ICE))
