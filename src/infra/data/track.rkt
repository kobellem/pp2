#lang racket
;Author Koen Bellemans

(require racket/set)
(provide track%)

(define-serializable-class* track% object% (externalizable<%>)
  (super-new)
  ;public methods
  (public add-segment get-segment get-length get-ids)
  ;variable initialization
  (init)
  (define segments (mutable-set))
  ;abstraction
  (define (id seg)(car seg))
  (define (nodes seg)(cdr seg))
  ;public methods
  (define (add-segment id_ node1 node2)
    (define segment (cons id_ (cons node1 node2)))
    (set-add! segments segment)
    (send node1 add-segment id_)
    (send node2 add-segment id_))
  (define (get-segment id_)
    (find-segment (set-copy segments) id_))
  (define (get-length id_)
    (let ([seg (find-segment (set-copy segments) id_)])
      (if seg
        (calculate-length (nodes seg))
        #f)))
  (define (get-ids) (list-ids))
  ;private methods
  (define (find-segment st id_)
    (if (not (set-empty? st))
      (let ([current (set-first st)])
        (if (eq? (id current) id_)
          current
          (begin
            (set-remove! st current) 
            (find-segment st id_))))
      #f))
  (define (calculate-length nodes)
    (let* ([node1 (car nodes)]
           [node2 (cdr nodes)]
           [c1 (send node1 get-coordinates)]
           [c2 (send node2 get-coordinates)])
      (sqrt (+ (expt (- (car c2) (car c1)) 2) (expt (- (cdr c2) (cdr c1)) 2)))))
  (define (list-ids)
    (define ids '())
    (for*/mutable-set ([seg segments])
      (set! ids (append ids (list (id seg)))))
    ids)
  ;externalizable interface
  (define/public (externalize) segments)
  (define/public (internalize s) (set! segments s)))
