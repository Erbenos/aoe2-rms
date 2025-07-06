#lang racket

(require threading)
(require racket/mutable-treelist)
(require "ast.rkt")
(require "ast-utils.rkt")

(define (%comment text)
  (~> (ast-comment-node (mutable-treelist) text) append-ast-node!))

(provide (all-defined-out))
