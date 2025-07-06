#lang aoe2-rms

(%raw "This will not show up in result.")

(define (my-fn x)
  (%const 'MYVAR x))

(provide (all-defined-out))
