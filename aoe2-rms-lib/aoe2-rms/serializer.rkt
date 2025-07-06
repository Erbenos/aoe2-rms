#lang racket

(require "ast.rkt")
(require "ast-utils.rkt")
(require racket/mutable-treelist)
(require threading)

(define *serialize-output-port* (make-parameter (current-output-port)))

(define (with-prefix str depth)
  (~> (make-string (* depth 2) #\space)
      (string-append _ str)))

(define (serialize-with-prefix str depth)
  (~> (with-prefix str depth)
      (displayln (*serialize-output-port*))))

(define (serialize-ast-node-children node depth)
  (ast-node-for-each-child node (lambda (child) (serialize-ast-node child depth))))

(define (serialize-ast-root-node node [depth 0])
  (serialize-ast-node-children node depth))

(define (serialize-ast-attribute-node node [depth 0])
  (~> "~a~a"
      (format (ast-attribute-node-name node)
              (let ([values (~> (ast-attribute-node-values node)
                                (map (lambda (x) (format "~a" x)) _)
                                (string-join))])
                (if (= (string-length values) 0) values (string-append " " values))))
      (serialize-with-prefix depth)))

(define (serialize-ast-block-node node [depth 0])
  (~> "~a ~a{"
      (format (ast-attribute-node-name node)
              (let ([values (~> (ast-attribute-node-values node)
                                (map (lambda (x) (format "~a" x)) _)
                                (string-join))])
                (if (= (string-length values) 0) values (string-append values " "))))
      (serialize-with-prefix depth))
  (serialize-ast-node-children node (add1 depth))
  (~> "}" (serialize-with-prefix depth)))

(define (serialize-ast-cond-label-node node [depth 0])
  (~> "#define ~a"
      (format (ast-cond-label-node-name node))
      (serialize-with-prefix depth)))

(define (serialize-ast-cond-node node [depth 0])
  (serialize-ast-node-children node depth))

(define (serialize-ast-cond-branch-node node [depth 0])
  (let* ([parent (ast-cond-branch-node-parent node)]
         [index (ast-cond-branch-node-index node)]
         [label (ast-cond-branch-node-label node)]
         [first? (eqv? index 0)]
         [last? (eqv? (- (mutable-treelist-length (ast-node-children parent)) 1)
                      index)]
         [else? (eqv? (ast-cond-branch-node-label node) #f)])
    (when (and else? (not last?)) (raise-user-error 'ast-cond-branch-node-err "Else branch has to be last branch in %cond."))
    (cond [else? (serialize-with-prefix "else" depth)]
          [first? (~> "if ~a"
                      (format label)
                      (serialize-with-prefix depth))]
          [else (~> "elseif ~a"
                    (format label)
                    (serialize-with-prefix depth))])
    (serialize-ast-node-children node (add1 depth))
    (when last? (serialize-with-prefix "endif" depth))))

(define (serialize-ast-random-node node [depth 0])
  (~> "start_random" (serialize-with-prefix depth))
  (serialize-ast-node-children node (add1 depth))
  (~> "end_random" (serialize-with-prefix depth)))

(define (serialize-ast-random-branch-node node [depth 0])
  (~> "percent_chance ~a"
      (format (ast-random-branch-node-percentage node))
      (serialize-with-prefix depth))
  (serialize-ast-node-children node (add1 depth)))

(define (serialize-ast-section-node node [depth 0])
  (~> "<~a>"
      (format (ast-section-node-name node))
      (serialize-with-prefix depth)))

(define (serialize-ast-include-drs-node node [depth 0])
  (~> "#include_drs ~a"
      (format (ast-include-drs-node-path node))
      (serialize-with-prefix depth)))

(define (serialize-ast-const-node node [depth 0])
  (~> "#const ~a ~a"
      (format (ast-const-node-name node) (ast-const-node-value node))
      (serialize-with-prefix depth)))

(define (serialize-ast-include-xs-node node [depth 0])
  (~> "#includeXS ~a"
      (format (ast-include-xs-node-path node))
      (serialize-with-prefix depth)))

(define (serialize-ast-comment-node node [depth 0])
  (~> "/* ~a */"
      (format (ast-comment-node-text node))
      (serialize-with-prefix depth)))

(define (serialize-ast-raw-node node [depth 0])
  (~> "~a"
      (format (ast-raw-node-raw-text node))
      (displayln)))

(define (serialize-ast-node node [depth 0])
  (when (not (ast-node? node)) void)
  (cond
    [(ast-root-node? node)
     (serialize-ast-root-node node depth)]
    [(ast-block-node? node)
     (serialize-ast-block-node node depth)]
    [(ast-attribute-node? node)
     (serialize-ast-attribute-node node depth)]
    [(ast-cond-label-node? node)
     (serialize-ast-cond-label-node node depth)]
    [(ast-cond-node? node)
     (serialize-ast-cond-node node depth)]
    [(ast-cond-branch-node? node)
     (serialize-ast-cond-branch-node node depth)]
    [(ast-random-node? node)
     (serialize-ast-random-node node depth)]
    [(ast-random-branch-node? node)
     (serialize-ast-random-branch-node node depth)]
    [(ast-section-node? node)
     (serialize-ast-section-node node depth)]
    [(ast-include-drs-node? node)
     (serialize-ast-include-drs-node node depth)]
    [(ast-const-node? node)
     (serialize-ast-const-node node depth)]
    [(ast-include-xs-node? node)
     (serialize-ast-include-xs-node node depth)]
    [(ast-comment-node? node)
     (serialize-ast-comment-node node depth)]
    [(ast-raw-node? node)
     (serialize-ast-raw-node node depth)]))

(define (serialize node [output (current-output-port)])
  (parameterize ([*serialize-output-port* output])
    (serialize-ast-node node)))

(provide serialize)
