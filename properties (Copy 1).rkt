#lang racket

(require
 "./compiler.rkt"
 "./processor.rkt"
 "./input-gen.rkt"
 "regex.rkt"
 rackcheck
 rackunit
 redex/reduction-semantics
 )


(define-property gen-wf
  (
   [expr (gen:const (compiler:gen))]
   [compiled (gen:const (term (compile ,expr)))]
   [in (gen:const (gen-input expr 5))]
   [pout (gen:const (get-processor-output (apply-reduction-relation* ->e  (term ,(0 (car compiled) compiled in '() #f)))))] ;; processor output
   [rout (gen:const (judgment-holds (in-regex expr in p) p))] ;; regex output
    )
  (eq? pout rout)
  )

;; (define reduction (apply-reduction-relation* ->e  (term (0 (char 10) ((char 10) (split 0 2) (char 20) (split 2 4) mtch) (10 10 20) () #f))))

(check-property (make-config #:tests 1)
                gen-wf)
