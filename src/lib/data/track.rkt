#lang racket
;Author Koen Bellemans

(require racket/set)
(require "segment.rkt")
(provide track%)

(define-serializable-class* track% object% (externalizable<%>)
  (super-new)
  ;public methods
  (public add-segment get-segment for-each-segment for-each-node)
  ;variable initialization
  (init)
  (define segments (mutable-set))
  ;abstraction
  (define (id seg)(send seg get-id))
  (define (nodes seg)(send seg get-nodes))
  ;public methods
  (define (add-segment id_ node1 node2)
    (set-add! segments (make-segment id_ node1 node2)))
  (define (get-segment id_)
    (find-segment (set-copy segments) id_))
  (define (for-each-segment proc)
    (for/mutable-set ([seg segments])
      (proc seg)))
  ;NOTE: Not realy for each node, since endpoint nodes that that aren't a car of any segment are not treated.
  ;As for now this function is only used to make a switches list upon initialization of the simulator, and endpoint nodes could never be a switch.
  (define (for-each-node proc)
    (let ([visited '()])
      (for-each-segment (lambda (seg)
        (let ([node (car (send seg get-nodes))])
          (when (not (member node visited))
            (begin
              (set! visited (append visited (list node)))
              (proc node))))))))
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
  ;externalizable interface
  (define/public (externalize) segments)
  (define/public (internalize s) (set! segments s)))
