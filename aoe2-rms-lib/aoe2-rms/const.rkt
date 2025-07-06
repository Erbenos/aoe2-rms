#lang racket

(require racket/mutable-treelist)
(require threading)
(require "ast.rkt")
(require "ast-utils.rkt")

(define (%const name value)
  (~> (ast-const-node (mutable-treelist) name value) append-ast-node!))

(provide (all-defined-out))
