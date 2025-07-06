#lang racket

(require (for-syntax syntax/parse))
(require "cond.rkt")

(define-syntax (%unless stx)
  (syntax-parse stx
    [(_ label:expr body:expr ...)
     #`(%cond [label] [#f body ...])]))

(provide (all-defined-out))
