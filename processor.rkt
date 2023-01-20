#lang racket

(require redex)

(define-language RegexP
  (ch ::= natural)
  (sp ::= (ch ...))
  (n ::= natural)
  (pc ::= natural)
  (i ::= (char ch) (split n n) (jmp n) mtch)
  (ilist ::= (i ...))
  (state ::= (pc i ilist sp p boolean))
  (p ::= (ch ...))
  )

(define ->e
  (reduction-relation RegexP
                      #:domain state
                      #:codomain state
                      (--> (pc mtch ilist () p #f) (pc mtch ilist () p #t) "match")
                      (--> (pc (char ch_1) ilist (ch_1 ch ...) (ch_2 ...) #f) (,(add1 (term pc)) (fetch ,(add1 (term pc)) ilist) ilist (ch ...) (ch_2 ... ch_1) #f) "char")
                      (--> (pc (jmp n) ilist (ch ...) p #f) (n (fetch n ilist) ilist (ch ...) p #f) "jmp")
                      (--> (pc (split n_1 n) ilist (ch ...) p #f) (n_1 (fetch n_1 ilist) ilist (ch ...) p #f) "split1")
                      (--> (pc (split n n_2) ilist (ch ...) p #f) (n_2 (fetch n_2 ilist) ilist (ch ...) p #f) "split2")
                      ))

(define-metafunction RegexP
  fetch : natural ilist -> i
  [(fetch (length ilist) ilist) ()]
  [(fetch natural (i ...)) ,(list-ref (term (i ...)) (term natural))])

;; (traces ->e (term (0 (char 10) ((char 10) (split 0 2) (char 20) (split 2 4) mtch) (10 10 20) () #f)))


(define (is-result r)
  (match r
    [(list pc i ilist sp p #t) #t]
    [_ #f]
    ))

(define (filter-result r)
  (filter is-result r))


(define (get-processor-output r)
  (list-ref (car (filter-result r)) 4))

(define (get-reduction expr in)
  (apply-reduction-relation* ->e  (term (0 (list-ref expr 0) expr in () #f))))

(define reduction (apply-reduction-relation* ->e  (term (0 (char 10) ((char 10) (split 0 2) (char 20) (split 2 4) mtch) (10 10 20) () #f))))

;; (get-processor-output reduction)

(provide (all-defined-out))
