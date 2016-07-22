#lang racket
;Author Koen Bellemans

(require racket/set)
(require "data/train.rkt")
(provide trainHandler%)

(define trainHandler%
  (class object%
    (super-new)
    (public add-train get-train get-trains)
    ;variable-initialization
    (define trains (mutable-set))
    ;abstraction
    (define (id train)(send train get-id))
    ;public methods
    (define (add-train id_ pos)
      (set-add! trains (list (make-train id_ pos))))
    (define (get-train id_)
      (find-train (set-copy trains) id_))
    (define (get-trains) trains)
    ;private methods
    (define (find-train st id_)
      (if (set-empty? st)
        #f
        (let ([current (set-first st)])
          (if (string=? (id current) id_)
            current
          (begin
            (set-remove! st current)
            (find-train st id_))))))))
