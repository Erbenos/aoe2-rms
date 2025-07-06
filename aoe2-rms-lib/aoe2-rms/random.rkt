#lang racket

(require (for-syntax syntax/parse))
(require (for-syntax racket/list))
(require racket/mutable-treelist)
(require "ast.rkt")
(require "ast-utils.rkt")
(require "scope.rkt")

(define-syntax (%random stx)
  (syntax-parse stx
    [(_ [chance:expr . body:expr] ...)
     (let* ([chances (syntax->list #'(chance ...))]
            [bodies (syntax->list #'(body ...))]
            [bodies-thunks (map (lambda (x) #`(list #,@(map (lambda (y) #`(thunk #,y)) (syntax->list x)))) bodies)]
            [branches
             (map
              (lambda (branch-index)
                #`(list #,(list-ref chances branch-index)
                        #,(list-ref bodies-thunks branch-index)))
              (range (length chances)))])
       #`(let ([random-node (ast-random-node (mutable-treelist))])
           (parameterize ([*parent* random-node])
             (for-each
              (lambda (branch)
                (let* ([branch-chance (first branch)]
                       [branch-body-fns (second branch)]
                       [branch-node (ast-random-branch-node (mutable-treelist) branch-chance)])
                  (parameterize ([*parent* branch-node])
                    (for-each (lambda (body-fn) (body-fn)) branch-body-fns))
                  (append-ast-node! branch-node)))
              (list #,@branches)))
           (append-ast-node! random-node)))]))

(provide (all-defined-out))
