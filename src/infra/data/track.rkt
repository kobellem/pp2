#lang racket
;Author Koen Bellemans

(require racket/set)
(require "segment.rkt")
(provide track%)

(define-serializable-class* track% object% (externalizable<%>)
  (super-new)
  ;public methods
  (public add-segment get-segment get-ids)
  ;variable initialization
  (init)
  (define segments (mutable-set))
  ;abstraction
  (define (id seg)(send seg get-id))
  (define (nodes seg)(send seg get-nodes))
  ;public methods
  (define (add-segment id_ node1 node2)
    (let ([segment (make-segment id_ node1 node2)])
      (set-add! segments segment)
      (send node1 add-segment id_)
      (send node2 add-segment id_)))
  (define (get-segment id_)
    (find-segment (set-copy segments) id_))
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
  (define (list-ids)
    (define ids '())
    (for*/mutable-set ([seg segments])
      (set! ids (append ids (list (id seg)))))
    ids)
  ;externalizable interface
  (define/public (externalize) segments)
  (define/public (internalize s) (set! segments s)))
