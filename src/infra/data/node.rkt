#lang racket
;Author Koen Bellemans

(provide node%)

(define node%
  (class object%
    (super-new)
    ;public methods
    (public get-id get-coordinates)
    ;variable initialization
    (init id x y)
    (define id_ id)
    (define coordinates (cons x y))
    ;method definitions
    (define (get-id) id_)
    (define (get-coordinates) coordinates)))
