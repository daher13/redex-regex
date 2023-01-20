#lang racket

(require redex
         "./compiler.rkt"
         "./processor.rkt"
         "./input-gen.rkt"
         rackcheck
         "regex.rkt"
         )

;; (term (compile (+ 10 (* (+ 10 20)))))

(define generated (compiler:gen))
generated

(define input (sample (gen-input generated 5) 1))

;; (judgment-holds (in-regex generated input p) p)

;; (define compiled (term (compile ,generated)))
;; compiled
