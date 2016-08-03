#lang racket
;Author Koen Bellemans

(provide make-node)

(define (make-node id x y)
  (define node (new node%))
  (send node set-id! id)
  (send node set-coordinates! x y)
  node)

(define-serializable-class* node% object% (externalizable<%>)
  (super-new)
  ;public methods
  (public set-id! get-id set-coordinates! get-x get-y add-segment get-segments get-alt-segments is-switch? switch is-switched? get-connected-segments)
  ;variable initialization
  ;No initialization arguments to support serialization
  (define id #f)
  (define coordinates #f)
  (define seg1 #f)
  (define seg2 #f)
  (define alt-seg #f)
  (define switched? #f)
  ;public methods
  (define (set-id! id_) (set! id id_))
  (define (get-id) id)
  (define (set-coordinates! x y) (set! coordinates (cons x y)))
  (define (get-x) (car coordinates))
  (define (get-y) (cdr coordinates))
  (define (add-segment seg)
    (cond
      [(not seg1) (set! seg1 seg)]
      [(not seg2) (set! seg2 seg)]
      [(not alt-seg) (set! alt-seg seg)]
      [else (error "Node" id "already has 3 segments")]))
  (define (get-segments) (list seg1 seg2))
  (define (get-alt-segments)(if (is-switch?)(list seg1 alt-seg) #f))
  (define (is-switch?) (if alt-seg #t #f))
  (define (switch) (if (is-switch?)
                     (if switched?
                       (set! switched? #f)
                       (set! switched? #t))
                     #f)
                   #t)
  (define (is-switched?) switched?)
  (define (get-connected-segments)
    (if (switched?)
      (get-alt-segments)
      (get-segments)))
  ;private methods
  (define (swap-seg)
    (let ([temp seg2])
      (set! seg2 alt-seg)
      (set! alt-seg temp)))
  ;externalizable interface
  (define/public (externalize) (list id coordinates seg1 seg2 alt-seg))
  (define/public (internalize lst)
    (set-id! (car lst))
    (set-coordinates! (caadr lst) (cdadr lst))
    (set! seg1 (caddr lst))
    (set! seg2 (cadddr lst))
    (set! alt-seg (car (cddddr lst)))))
