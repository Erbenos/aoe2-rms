#lang racket

(require threading)
(require racket/mutable-treelist)
(require "ast.rkt")
(require "ast-utils.rkt")

(define (%raw raw-text)
  (~> (ast-raw-node (mutable-treelist) raw-text) append-ast-node!))

(provide (all-defined-out))
