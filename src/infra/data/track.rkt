#lang racket
;Author Koen Bellemans

(require racket/set)
(provide track%)

(define track%
  (class object%
    (super-new)
    ;public methods
    (public add-segment get-segment get-length)
    ;variable initialization
    (init)
    (define segments (mutable-set))
    ;public methods
    (define (add-segment id node1 node2)
      (define segment (cons id (cons node1 node2)))
      (set-add! segments segment)
      (send node1 add-segment id)
      (send node2 add-segment id))
    (define (get-segment id)
      (find-segment segments id))
    (define (get-length id)
      (let ([seg (find-segment segments id)])
        (if seg
          (calculate-length (cdr seg))
          #f)))
    ;private methods
    (define (find-segment st id)
      (if (not (set-empty? st))
        (let ([current (set-first st)])
          (if (eq? (car current) id)
            current
            (begin
              (set-remove! st current) 
              (find-segment st id))))
        #f))))
    (define (calculate-length nodes)
      (let* ([node1 (car nodes)]
             [node2 (cdr nodes)]
             [c1 (send node1 get-coordinates)]
             [c2 (send node2 get-coordinates)])
        (sqrt (+ (expt (- (car c2) (car c1)) 2) (expt (- (cdr c2) (cdr c1)) 2)))))
