#lang racket

(require rackcheck)

(define (cgen:char)
  (gen:integer-in 1 99))

(define (cgen:expr n)
  (cond
    [(positive? n) (gen:choice
                    (cgen:char)
                    (gen:let ([e (cgen:expr (sub1 n))])
                             (gen:const (list '* e)))
                    (gen:let ([e1 (cgen:expr (sub1 n))]
                              [e2 (cgen:expr (sub1 n))])
                             (gen:const (list '+ e1 e2)))
                    )]
    [else (cgen:char)]
    ))

(define expr-test (sample (cgen:expr 3) 1))

(define (compiler-generate)
  (define expr (sample (cgen:expr 5) 1))
  (car expr))

(compiler-generate)

(provide compiler-generate)
