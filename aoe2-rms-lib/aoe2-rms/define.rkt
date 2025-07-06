#lang racket

(require racket/mutable-treelist)
(require threading)
(require "ast.rkt")
(require "ast-utils.rkt")

(define (%define name)
  (~> (ast-cond-label-node (mutable-treelist) name) append-ast-node!))

(provide (all-defined-out))
