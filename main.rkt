#lang racket

(require redex
         "./compiler.rkt"
         "./processor.rkt"
         )

(term (compile (+ 10 (* (+ 10 20)))))

;; (define generated (compiler:gen))
;; generated
;; (define compiled (term (compile ,generated)))
;; compiled
