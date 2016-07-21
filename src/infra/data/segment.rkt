#lang racket
;Author Koen Bellemans

(provide make-segment)

(define (make-segment id node1 node2)
  (let ([segment (new segment%)])
    (send* segment (set-id! id)(set-nodes! node1 node2))
    segment))

(define-serializable-class* segment% object% (externalizable<%>)
  (super-new)
  (public set-id! get-id set-nodes! get-nodes get-length)
  ;no initialization arguments to support serialization
  (define id #f)
  (define nodes #f)
  (define l #f)
  ;public methods
  (define (set-id! id_)(set! id id_))
  (define (get-id) id)
  (define (set-nodes! node1 node2)
    (set! nodes (cons node1 node2))
    (calculate-length))
  (define (get-nodes) nodes)
  (define (get-length) l)
  ;private methods
  (define (calculate-length)
    (let* ([node1 (car nodes)]
           [node2 (cdr nodes)]
           [c1 (send node1 get-coordinates)]
           [c2 (send node2 get-coordinates)])
      (set!  l (sqrt (+ (expt (- (car c2) (car c1)) 2) (expt (- (cdr c2) (cdr c1)) 2))))))
  ;externalizable interface
  (define/public (externalize)(list id nodes))
  (define/public (internalize lst)
    (set-id! (car lst))
    (set-nodes! (caadr lst)(cdadr lst))))
