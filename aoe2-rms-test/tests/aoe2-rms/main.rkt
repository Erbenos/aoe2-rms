#lang racket

(module test racket
  (require
    threading
    rackunit
    rackunit/text-ui
    racket/path)

  (define test-file-name-regex #rx"^[0-9]+\\.rkt$")

  (define (directory->test-suites-hash dir)
    (define base-path (~> dir string->path simplify-path))
    (for/fold ([groups (hash)])
              ([test-file-path (in-directory base-path)]
               #:when (~> test-file-path
                          file-name-from-path
                          path->string
                          (regexp-match? test-file-name-regex _)))
      (let* ([test-file-folder-path (~> test-file-path
                                        path-only
                                        simplify-path)]
             [test-file-output-file-path (~> test-file-path path->string (string-append ".out") string->path)]
             [files (hash-ref groups test-file-folder-path '())])
        (if (file-exists? test-file-output-file-path)
            (hash-set groups test-file-folder-path (append files `((,test-file-path ,test-file-output-file-path))))
            groups))))

  (define (test-case-blueprint->test-case source-path expected-output-path)
    (test-case
     (~> source-path file-name-from-path path->string)
     (define expected-result (file->string expected-output-path))
     (define command (format "~a ~a" "racket" (path->string source-path)))
     (define actual-result (with-output-to-string (lambda () (system command))))
     (check-equal? actual-result expected-result)))

  (define (test-suit-hash-record->test-suite key value)
    (test-suite
     (path->string key)
     (map (lambda (test-case-blueprint)
            (test-case-blueprint->test-case
             (first test-case-blueprint) (second test-case-blueprint)))
          value)))

  (~>
   "specs"
   directory->test-suites-hash
   (hash-map test-suit-hash-record->test-suite)
   (test-suite "aoe2-rms" _)
   run-tests))
