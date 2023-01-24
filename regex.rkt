#lang racket

(require redex)

(define-language RegexL
  (e ::= eps natural (+ e e) (e e) (* e))
  (s ::= (n ...))
  (p ::= (natural ...) fail)
  (n ::= natural)
  )

(define-judgment-form RegexL
  #:mode     (in-regex I I O)
  #:contract (in-regex e s p)

  [
   ---------------------------"T-eps"
   (in-regex eps s ())
   ]

  [
   ----------------------------------------------------------"T-char"
   (in-regex natural_1 (natural_1 natural ...) (natural_1))
   ]

  [
   (side-condition (diff natural_1 natural_2))
   ----------------------------------------------------------"T-char-fail"
   (in-regex natural_1 (natural_2 natural ...) fail)
   ]

  [
   ----------------------------------------------------------"T-char-empty"
   (in-regex natural_1 () fail)
   ]

  [
   (in-regex e_1 (n_1 ... n_2 ...) (n_1 ...))
   (in-regex e_2 (n_2 ...) (n_3 ...))
   ----------------------------------------------------------"T-cat"
   (in-regex (e_1 e_2) (n_1 ...  n_2 ...) (n_1 ... n_3 ...))
   ]

  [
   (in-regex e_1 (n_1 ... n_2 ...) fail)
   ----------------------------------------------------------"T-cat-fail"
   (in-regex (e_1 e_2) (n_1 ...  n_2 ...) fail)
   ]

  [
   (in-regex e_1 (n_1 ... n_2 ...) (n_1 ...))
   (in-regex e_2 (n_2 ...) fail)
   ----------------------------------------------------------"T-cat-fail-2"
   (in-regex (e_1 e_2) (n_1 ...  n_2 ...) fail)
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
   (in-regex e_1 (n_1 ...) fail)
   (in-regex e_2 (n_1 ...) fail)
   ----------------------------------------------------------"T-or-fail"
   (in-regex (+ e_1 e_2) (n_1 ...) fail)
   ]

  [
   (in-regex e_1 s fail)
   ----------------------------------------------------------"T-star-eps"
   (in-regex (* e_1) s ())
   ]

  [
   (in-regex e_1 (n_1 ... n_2 ... n_3 ...) (n_1 ...))
   (in-regex (* e_1) (n_2 ... n_3 ...) (n_2 ...))
   ---------------------------------------------------------------"T-star-1"
   (in-regex (* e_1) (n_1 ... n_2 ... n_3 ...) (n_1 ... n_2 ...))
   ]
  )


(define-metafunction RegexL
  diff : natural natural -> boolean
  [(diff natural_1 natural_1) #f]
  [(diff natural_1 natural_2) #t])

(provide (all-defined-out))
