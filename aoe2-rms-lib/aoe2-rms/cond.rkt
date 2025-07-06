#lang racket

(require (for-syntax syntax/parse))
(require (for-syntax racket/list))
(require racket/mutable-treelist)
(require "ast.rkt")
(require "ast-utils.rkt")
(require "scope.rkt")

(define (map-with-index f lst)
  (map f lst (build-list (length lst) identity)))

(define-syntax (%cond stx)
  (syntax-parse stx
    [(_ [label:expr . body:expr] ...)
     (let* ([labels (syntax->list #'(label ...))]
            [bodies (syntax->list #'(body ...))]
            [bodies-thunks (map (lambda (x) #`(list #,@(map (lambda (y) #`(thunk #,y)) (syntax->list x)))) bodies)]
            [branches
             (map
              (lambda (branch-index)
                #`(list #,(list-ref labels branch-index)
                        #,(list-ref bodies-thunks branch-index)))
              (range (length labels)))])
       #`(let* ([cond-node (ast-cond-node (mutable-treelist))]
                [cond-branches (list #,@branches)]
                [branch-count (length cond-branches)]
                [branches-with-indices (map-with-index (lambda (value index) (list value index)) cond-branches)])
           (parameterize ([*parent* cond-node])
             (for-each
              (lambda (branch-with-index)
                (let* ([branch-index (second branch-with-index)]
                       [branch (first branch-with-index)]
                       [branch-label (first branch)]
                       [branch-body-fns (second branch)]
                       [branch-node (ast-cond-branch-node (mutable-treelist) branch-label branch-index cond-node)])
                  (parameterize ([*parent* branch-node])
                    (for-each (lambda (body-fn) (body-fn)) branch-body-fns))
                  (append-ast-node! branch-node)))
              branches-with-indices))
           (append-ast-node! cond-node)))]))

(provide (except-out (all-defined-out) map-with-index))
