#lang racket

(define (%random-number min max)
  (format "rnd(~a,~a)" min max))

(provide (all-defined-out))
