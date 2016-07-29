#lang racket
;Author Koen Bellemans

(provide simHandler%)

(define simHandler%
  (class object%
    (super-new)
    (public init add-train get-trains)
    ;variable initialization
    (define track #f)
    (define trains '())
    ;abstraction
    (define (id train)(car train))
    (define (pos train)(cadr train))
    (define (speed train)(caddr train))
    ;public methods
    (define (init t)
      (set! track t))
    (define (add-train id_ pos_)
      (set! trains (list '(id_ pos_ 0) trains)))
    (define (get-trains) trains)
    ;private methods
    (define (find-train lst id_)
      (if (empty? lst)
        #f
        (let ([current (car lst)])
          (if (string=? (id current) id_)
            current
            (find-train (cdr lst) id_)))))
))
