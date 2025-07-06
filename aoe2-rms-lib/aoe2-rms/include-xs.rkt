#lang racket

(require racket/mutable-treelist)
(require threading)
(require "ast.rkt")
(require "ast-utils.rkt")

(define (%include-xs path)
  (~> (ast-include-xs-node (mutable-treelist) path) append-ast-node!))

(provide (all-defined-out))
