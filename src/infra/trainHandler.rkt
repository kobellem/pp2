#lang racket
;Author Koen Bellemans

(require racket/set data/queue)
(require "../lib/data/train.rkt")
(provide trainHandler%)

(define trainHandler%
  (class object%
    (super-new)
    (public add-train get-train get-trains goto)
    ;variable-initialization
    (init-field track)
    (define trains (mutable-set))
    ;abstraction
    (define (id train)(send train get-id))
    ;public methods
    (define (add-train id_ pos)
      (set-add! trains (make-train id_ pos)))
    (define (get-train id_)
      (find-train (set-copy trains) id_))
    (define (get-trains) trains)
    (define (goto id_ pos)
      (let ([train (get-train id_)])
        (if train
          (begin 
            ;stop the train if it's moving
            (send train set-speed! 0)
            ;calculate the route and send it to the train
            (send train set-route! (calculate-route track train pos)))
          (error "Train not found"))))
    ;private methods
    (define (find-train st id_)
      (if (set-empty? st)
        #f
        (let ([current (set-first st)])
          (if (string=? (id current) id_)
            current
          (begin
            (set-remove! st current)
            (find-train st id_))))))
))

(define (calculate-route track train to)
  (define queue (make-queue))
  (let loop ([route '()]
             [from (send train get-position)])
    (if (equal? from to)
      (append route (list from))
      (let* ([node (cdr (send from get-nodes))]
             [next-seg-id (cdr (send node get-segments))]
             [next-seg (send track get-segment next-seg-id)])
        (loop (append route (list from)) next-seg)))))
