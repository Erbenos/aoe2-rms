#lang racket

(struct ast-node (children) #:transparent)
(struct ast-root-node ast-node () #:transparent)
(struct ast-attribute-node ast-node (name values) #:transparent)
(struct ast-block-node ast-attribute-node () #:transparent)
(struct ast-cond-label-node ast-node (name) #:transparent)
(struct ast-cond-node ast-node () #:transparent)
(struct ast-cond-branch-node ast-node (label index parent) #:transparent)
(struct ast-random-node ast-node () #:transparent)
(struct ast-random-branch-node ast-node (percentage) #:transparent)
(struct ast-section-node ast-node (name) #:transparent)
(struct ast-include-drs-node ast-node (path) #:transparent)
(struct ast-const-node ast-node (name value) #:transparent)
(struct ast-include-xs-node ast-node (path) #:transparent)
(struct ast-comment-node ast-node (text) #:transparent)
(struct ast-raw-node ast-node (raw-text) #:transparent)

(provide (all-defined-out))
