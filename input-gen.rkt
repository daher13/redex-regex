#lang racket

(require
 "./compiler.rkt"
 rackcheck
 redex
 )

(define (gen-input e n)
  (match e
    ['eps (gen:const '())]
    [(? natural? e) (gen:const (list e))]
    [(list '* e1) (gen:repeat (gen-input e1 n) n)]
    [(list '+ e1 e2) (gen:choice (gen-input e1 n) (gen-input e2 n))]
    [(list e1 e2) (gen:bind
                   (gen-input e1 n)
                   (lambda (s1)
                     (gen:bind (gen-input e2 n)
                               (lambda (s2)
                                 (gen:const (append s1 s2))))))]
    ))
  


(define (gen:repeat g n)
  (if (eq? n 0)
      (gen:const null)
      (gen:bind (gen:repeat g (- n 1) )
                (lambda (xs) (gen:bind g
                                (lambda (x) (gen:const (append x xs))))))))


(provide gen-input)

;; (sample (gen-input (list '* 20) 5) 1)
