#lang racket

(require redex)

(define-language RegexL
  (e ::= eps natural (+ e e) (e e) (* e))
  (s ::= (n ...) eps)
  (t ::= eps char or cat star)
  (p ::= (natural ...))
  (n ::= natural)
  )

(define-judgment-form RegexL
  #:mode     (in-regex I I O)
  #:contract (in-regex e s p)

  [
   ---------------------------"T-eps"
   (in-regex eps s eps)
   ]

  [
   ----------------------------------------------------------"T-char"
   (in-regex natural_1 (natural_1 natural ...) (natural_1))
   ]

  [
   (in-regex e_1 (n_1 ... n_2 ...) (n_1 ...))
   (in-regex e_2 (n_2 ...) (n_3 ...))
   ----------------------------------------------------------"T-cat"
   (in-regex (e_1 e_2) (n_1 ...  n_2 ...) (n_1 ... n_3 ...))
   ]

  [
   (in-regex e_1 (n_1 ...) (n_2 ...))
   ----------------------------------------------------------"T-or-1"
   (in-regex (+ e_1 e_2) (n_1 ...) (n_2 ...))
   ]

  [
   (in-regex e_2 (n_1 ...) (n_2 ...))
   ----------------------------------------------------------"T-or-2"
   (in-regex (+ e_1 e_2) (n_1 ...) (n_2 ...))
   ]

  [
   ----------------------------------------------------------"T-star-eps"
   (in-regex (* e) s ())
   ]

  )

;; (judgment-holds (in-regex ((+ 2 3) (+ 4 5)) (2 5) p) p)
(judgment-holds (in-regex ((* 2)) eps p) p)
