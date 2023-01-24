#lang racket

(require redex rackcheck)

(require "./processor.rkt")

(define-language RegexC
  (ch ::= natural)
  (n ::= natural)
  (p ::= natural)
  (x ::= natural)
  (y ::= natural)
  (i ::= ch * ? +)
  (op ::= (i n))
  (input ::= (op ...))
  (vm ::= (char ch) (split x y) (jmp x) mtch)
  (vmlist ::= (vm ...))
  (state ::= (vmlist input))
  (exp ::= eps natural (+ exp exp) (exp exp) (* exp))
  )

(define-metafunction RegexC
  compileN : natural exp -> vmlist
  [(compileN natural_1 natural_2) ((char natural_2))]
  [(compileN natural (+ exp_1 exp_2)) (mk-choice natural (compileN (sum (natural 1)) exp_1) exp_2)]
  [(compileN natural (exp_1 exp_2)) (mk-seq natural (compileN natural exp_1) exp_2)]
  [(compileN natural (* exp)) (mk-kleene natural (compileN natural exp))]
  )

(define-metafunction RegexC
  compile : exp -> vmlist
  [(compile exp) (imatch (compileN 0 exp))]
  )

(define-metafunction RegexC
  imatch : vmlist -> vmlist
  [(imatch (vm ...)) (vm ... mtch)])

(define-metafunction RegexC
  mk-seq : natural vmlist exp -> vmlist
  [(mk-seq natural (vm_1 ...) exp) (cat (vm_1 ...) (compileN (shift natural (vm_1 ...)) exp))])

(define-metafunction RegexC
  mk-choice : natural vmlist exp -> vmlist
  [(mk-choice natural (vm_1 ...) exp) (mk-choice2 natural (vm_1 ...) (compileN (sum (2 natural (sz (vm_1 ...)))) exp))])

(define-metafunction RegexC
  mk-choice2 : natural vmlist vmlist -> vmlist
  [(mk-choice2 natural (vm_1 ...) (vm_2 ...)) ((split (sum (natural 1)) (sum (natural (sz (vm_1 ...)) 2))) vm_1 ... (jmp (sum (natural (sz (vm_1 ...)) (sz (vm_2 ...)) 2))) vm_2 ...)])

(define-metafunction RegexC
  mk-kleene : natural vmlist -> vmlist
  [(mk-kleene natural (vm_1 ...)) ((split (sum (natural 1)) (sum (natural (sz (vm_1 ...)) 2))) vm_1 ... (jmp natural))])

(define-metafunction RegexC
  sum : (natural ...)  -> natural
  [(sum ()) 0]
  [(sum (natural_1 natural_2 ...)) ,(+ (term natural_1) (term (sum (natural_2 ...))))])

(define-metafunction RegexC
  cat : vmlist vmlist -> vmlist
  [(cat (vm_1 ...) (vm_2 ...)) (vm_1 ... vm_2 ...)])

(define-metafunction RegexC
  sz : vmlist -> natural
  [(sz (vm ...)) ,(length (term (vm ...)))])

(define-metafunction RegexC
  shift : natural vmlist -> natural
  [(shift natural (vm ...)) ,(+ (term (sz (vm ...))) (term natural) )])

(define (cgen:char)
  (gen:integer-in 1 99))

(define (cgen:expr n)
  (cond
    [(positive? n) (gen:choice
                    (cgen:char)
                    (gen:let ([e (cgen:expr (sub1 n))])
                             (gen:const (term (* ,e))))
                    (gen:let ([e1 (cgen:expr (sub1 n))]
                              [e2 (cgen:expr (sub1 n))])
                             (gen:const (term (+ ,e1 ,e2))))
                    )]
    [else (cgen:char)]
    ))

;; (define expr-test (sample (cgen:expr 3) 1))

;; (define (compiler:gen)
;;   (define expr (sample (cgen:expr 5) 1))
;;   (car expr)
;;   )

;; (term (compile (+ 2 3)))

(provide cgen:expr compile)
