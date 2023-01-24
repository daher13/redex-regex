#lang racket

(require
 "./compiler.rkt"
 "./input-gen.rkt"
 "./regex.rkt"
 "./vm.rkt"
 rackcheck
 rackunit
 redex/reduction-semantics
 redex
 )

(struct result
  (re str)
  #:transparent)

(define (gen:data n m)
  (gen:bind (cgen:expr n)
            (lambda (e) (gen:bind (gen-input e m)
                                  (lambda (s) (gen:const (result e s)))))))

(define-property gen-wf
  ((inp (gen:data 3 2)))
  (let (
        (x (judgment-holds (in-regex ,(result-re inp)
                            ,(result-str inp)
                            p) p))
        (y (vm:process (apply-reduction-relation* ->e (term (0 ,(list-ref (term (compile ,(result-re inp))) 0) (compile ,(result-re inp)) ,(result-str inp) () #f)))))
        )
    (equal? x y)))

;; (define inp (result '(* 87) '(87 87)))
;; (define inp (result '(+ (* (+ 1 1)) (+ (* 1) 2)) '(2)))

(define inp (result '(* 1) '(1)))
;; (define inp (result '(+ (+ 6 (* 34)) (+ (+ 86 18) 17)) '(18)))

;; x
(judgment-holds (in-regex ,(result-re inp)
                            ,(result-str inp)
                            p) p)

;; (term (compile ,(result-re inp)))

;; y
(vm:process (apply-reduction-relation* ->e (term (0 ,(list-ref (term (compile ,(result-re inp))) 0) (compile ,(result-re inp)) ,(result-str inp) () #f))))
;; (apply-reduction-relation* ->e (term (0 ,(list-ref (term (compile ,(result-re inp))) 0) (compile ,(result-re inp)) ,(result-str inp) () #f)))
;; (traces ->e (term (0 ,(list-ref (term (compile ,(result-re inp))) 0) (compile ,(result-re inp)) ,(result-str inp) () #f)))

;; (check-property (make-config #:tests 5) gen-wf)

