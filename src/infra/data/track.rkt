#lang racket
;Author Koen Bellemans

(require racket/set)
(provide track%)

(define track%
  (class object%
    (super-new)
    ;public methods
    (public add-segment get-segment)
    ;variable initialization
    (init)
    (define segments (mutable-set))
    ;public methods
    (define (add-segment id node1 node2)
      (define segment (cons id (cons node1 node2)))
      (set-add! segments segment))
    (define (get-segment id)
      (find-segment segments id))
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
