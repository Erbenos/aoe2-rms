#lang racket

(require (for-syntax syntax/parse))
(require racket/mutable-treelist)
(require threading)
(require "ast.rkt")
(require "ast-utils.rkt")
(require "scope.rkt")

(define-syntax (define-block stx)
  (syntax-parse stx
    [(_ name:id values:id ...)
     #`(define-syntax (name call-stx)
         (syntax-case call-stx ()
           [(_ values ... . body)
            (let* ([items (syntax->list #'body)]
                   [item-fns (map (lambda (y) #`(thunk #,y)) items)])
              #`(let ([block-node (ast-block-node (mutable-treelist) (~> 'name symbol->string underscorize) (list values ...))])
                  (parameterize ([*parent* block-node])
                    (for-each (lambda (item-fn) (item-fn)) (list #,@item-fns)))
                  (append-ast-node! block-node)))]))]))

(define-block create-object type)
(define-block create-object-group group-name)
(define-block create-player-lands)
(define-block create-land)
(define-block create-elevation n)
(define-block create-terrain type)
(define-block create-connect-all-players-land)
(define-block create-connect-teams-lands)
(define-block create-connect-all-lands)
(define-block create-connect-same-land-zones)
(define-block create-connect-land-zones zone1 zone2)
(define-block create-connect-to-nonplayer-land)

(provide (except-out (all-defined-out) define-block))
