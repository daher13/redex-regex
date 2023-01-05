#lang racket

(require redex)

(define-language RegexP
  (ch ::= natural)
  (sp ::= (ch ...))
  (n ::= natural)
  (pc ::= natural)
  (i ::= (char ch) (split n n) (jmp n) mtch)
  (ilist ::= (i ...))
  (state ::= (pc i ilist sp))
  )

(define ->e
  (reduction-relation RegexP
                      #:domain state
                      #:codomain state
                      (--> (pc mtch ilist ()) (pc mtch ilist ()))
                      (--> (pc (char ch_1) ilist (ch_1 ch ...)) (,(add1 (term pc)) (fetch ,(add1 (term pc)) ilist) ilist (ch ...)))
                      (--> (pc (jmp n) ilist (ch ...)) (n (fetch n ilist) ilist (ch ...)))
                      (--> (pc (split n_1 n) ilist (ch ...)) (n (fetch n_1 ilist) ilist (ch ...)))
                      (--> (pc (split n n_1) ilist (ch ...)) (n (fetch n_1 ilist) ilist (ch ...)))
                      ))

(define-metafunction RegexP
  fetch : natural ilist -> i
  [(fetch (length ilist) ilist) ()]
  [(fetch natural (i ...)) ,(list-ref (term (i ...)) (term natural))])

;; (traces ->e (term (0 (char 10) ((char 10) (split 0 2) (char 20) (split 2 4) mtch) (10 10 20))))

(provide (all-defined-out))
