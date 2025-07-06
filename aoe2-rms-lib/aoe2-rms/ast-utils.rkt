#lang racket

(require racket/mutable-treelist)
(require "scope.rkt")
(require "ast.rkt")

(define (underscorize str)
  (regexp-replace* #rx"-" str "_"))

(define (prepend-ast-node! node)
  (mutable-treelist-insert! (ast-node-children (*parent*)) 0 node)
  (void))

(define (append-ast-node! node)
  (mutable-treelist-add! (ast-node-children (*parent*)) node)
  (void))

(define (ast-node-for-each-child node fn)
  (mutable-treelist-for-each (ast-node-children node) fn))

(provide (all-defined-out))
