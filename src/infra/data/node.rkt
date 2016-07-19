#lang racket
;Author Koen Bellemans

(provide node%)

(define node%
  (class object%
    (super-new)
    ;public methods
    (public get-id get-coordinates add-segment get-segments is-switch? switch)
    ;variable initialization
    (init-field id)
    (init x y)
    (define coordinates (cons x y))
    (define seg1 #f)
    (define seg2 #f)
    (define seg3 #f)
    ;public methods
    (define (get-id) id)
    (define (get-coordinates) coordinates)
    (define (add-segment sid)
      (cond
        [(not seg1) (set! seg1 sid)]
        [(not seg2) (set! seg2 sid)]
        [(not seg3) (set! seg3 sid)]
        [else (error "Node" id "already has 3 segments")]))
    (define (get-segments) (cons seg1 seg2))
    (define (is-switch?) (if seg3 #t #f))
    (define (switch) (if (is-switch?) (swap-seg) #f))
    ;private methods
    (define (swap-seg)
      (let ([temp seg2])
        (set! seg2 seg3)
        (set! seg3 temp)))))
