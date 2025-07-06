#lang racket

(require (for-syntax racket/base))
(require "scope.rkt")
(require "syntax.rkt")
(require "serializer.rkt")
(require "ast.rkt")
(require racket/mutable-treelist)
(require racket/splicing)

(module reader syntax/module-reader
  aoe2-rms)

(define-syntax-rule (module-begin expr ...)
  (#%module-begin
   (define root (ast-root-node (mutable-treelist)))
   (splicing-parameterize ([*parent* root]) expr ...)
   (provide (rename-out [root ast]))
   (module+ main
     (define destination (box #f))
     (require racket/cmdline)
     (command-line
      #:program "aoe2-rms"
      #:once-each
      [("-d" "--dest") destination-arg "Destination path" (set-box! destination destination-arg)])
     (let ([dest (unbox destination)])
       (if dest
           (with-output-to-file (string->path dest) (thunk (serialize root)) #:exists 'replace)
           (serialize root))))))

(provide
 (except-out (all-from-out racket) #%module-begin)
 (rename-out [module-begin #%module-begin])
 (all-from-out "syntax.rkt" "scope.rkt"))
