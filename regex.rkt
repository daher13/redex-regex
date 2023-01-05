#lang racket

(require redex)

(define-language RegexL
  (ch ::= natural)
  (opor ::= ("+" ch ch))
  (opstar ::= ("*" ch))
  (e ::= opor opstar)
  (t ::= or star char)
  )


(define-judgment-form RegexL
  #:mode (types I O)
  #:contract (types e t)
  [
   --------------------"T-or"
   (types opor or)
   ]

  [
   --------------------"T-star"
   (types opstar star)
   ]

  [
   --------------------"T-char"
   (types ch char)
   ]
  
  )

(judgment-holds (types 2 char))
