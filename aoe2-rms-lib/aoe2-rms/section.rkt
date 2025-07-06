#lang racket

(require (for-syntax racket/function))
(require (for-syntax racket/syntax))
(require (for-syntax syntax/parse))
(require racket/mutable-treelist)
(require threading)
(require "ast.rkt")
(require "ast-utils.rkt")

(define-syntax (define-section stx)
  (syntax-parse stx
    [(_ name:id)
     #'(define (name)
         (~> (ast-section-node
              (mutable-treelist)
              (~> 'name symbol->string underscorize string-upcase))
             append-ast-node!))]))

(define-syntax (define-section-id-alias stx)
  (syntax-parse stx
    [(_ section:id alias:id)
     #'(define-syntax alias
         (lambda (stx) #'(section)))]))

(define-section elevation-generation)
(define-section player-setup)
(define-section land-generation)
(define-section cliff-generation)
(define-section terrain-generation)
(define-section connection-generation)
(define-section objects-generation)

(define-section-id-alias elevation-generation <ELEVATION-GENERATION>)
(define-section-id-alias player-setup <PLAYER-SETUP>)
(define-section-id-alias land-generation <LAND-GENERATION>)
(define-section-id-alias cliff-generation <CLIFF-GENERATION>)
(define-section-id-alias terrain-generation <TERRAIN-GENERATION>)
(define-section-id-alias connection-generation <CONNECTION-GENERATION>)
(define-section-id-alias objects-generation <OBJECTS-GENERATION>)

(provide (except-out (all-defined-out) define-section))
