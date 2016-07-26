#lang racket
;Author Koen Bellemans

(provide make-segment)

;TODO catch creatin a segment with a node that's already a swictch
(define (make-segment id node1 node2)
  (let ([segment (new segment%)])
    (send* segment (set-id! id)(set-nodes! node1 node2))
    (send node1 add-segment id)
    (send node2 add-segment id)
    segment))

(define-serializable-class* segment% object% (externalizable<%> equal<%>)
  (super-new)
  (public set-id! get-id set-nodes! get-nodes get-length set-state! state-eq?)
  ;no initialization arguments to support serialization
  (define id #f)
  (define nodes #f)
  (define l #f)
  (define state 0) ;states: 0=free, 1=reserved, 2=occupied
  ;public methods
  (define (set-id! id_)(set! id id_))
  (define (get-id) id)
  (define (set-nodes! node1 node2)
    (set! nodes (cons node1 node2))
    (calculate-length))
  (define (get-nodes) nodes)
  (define (get-length) l)
  (define (set-state! new-state)
    (cond
      [(eq? new-state 'free)(set! state 0)]
      [(eq? new-state 'reserved)(set! state 1)]
      [(eq? new-state 'occupied)(set! state 2)]
      [else #f])
    #t)
  (define (state-eq? s)
    (cond
      [(eq? s 'free)(eq? state 0)]
      [(eq? s 'reserved)(eq? state 1)]
      [(eq? s 'occupied)(eq? state 2)]
      [else #f]))
  ;private methods
  (define (calculate-length)
    (let* ([node1 (car nodes)]
           [node2 (cdr nodes)]
           [x1 (send node1 get-x)]
           [y1 (send node1 get-y)]
           [x2 (send node2 get-x)]
           [y2 (send node2 get-y)])
      (set!  l (sqrt (+ (expt (- x2 x1) 2) (expt (- y2 y1) 2))))))
  ;externalizable interface
  (define/public (externalize)(list id nodes state))
  (define/public (internalize lst)
    (set-id! (car lst))
    (set-nodes! (caadr lst)(cdadr lst))
    (set! state (caddr lst)))
  ;public equality intarface
  (define/public (equal-to? other recur)
    (eq? id (send other get-id)))
  (define/public (equal-hash-code-of hash)
    id)
  (define/public (equal-secondary-hash-code-of hash)
    id))
