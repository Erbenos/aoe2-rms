#lang racket

(require racket/mutable-treelist)
(require threading)
(require "ast.rkt")
(require "ast-utils.rkt")

(define (%include-drs path)
  (~> (ast-include-drs-node (mutable-treelist) path) append-ast-node!))

(provide (all-defined-out))
