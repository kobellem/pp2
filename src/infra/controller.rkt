#lang racket
;Author Koen Bellemans

(require racket/set data/queue)
(require "../lib/data/train.rkt")
(provide controller%)

(define controller%
  (class object%
    (super-new)
    (public add-train get-train get-trains goto update)
    ;variable-initialization
    (init-field track requester)
    (define trains (mutable-set))
    ;abstraction
    (define (id train)(send train get-id))
    (define (position train)(send train get-position))
    (define (stop train)(send requester request "set-speed" (list (send train get-id) 0 #t)))
    (define (start train)(send requester request "set-speed" (list (send train get-id) 10 #t)))
    ;public methods
    (define (add-train id_ pos)
      (set-add! trains (make-train id_ pos))
      (send requester request "add-train" (list id_ pos)))
    (define (get-train id_)
      (find-train (set-copy trains) id_))
    (define (get-trains) trains)
    (define (goto id_ pos)
      (let ([train (get-train id_)])
        (if train
          (begin 
            ;stop the train if it's moving
            (stop train)
            ;calculate the route and send it to the train
            (send train set-route! (calculate-route track train pos))
            ;start the train
            (start train))
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
    (define (calculate-route track train to)
      (define queue (make-queue))
      (let loop ([route '()]
                 [from (position train)])
        (if (equal? from to)
          (append route (list from))
          (let* ([node (cdr (send from get-nodes))]
                 [next-seg-id (cdr (send node get-segments))]
                 [next-seg (send track get-segment next-seg-id)])
            (loop (append route (list from)) next-seg)))))
    ;update thread
    (define (update) (lambda ()
      (let loop ([ts (send requester request "get-trains")])
        (when (not (empty? ts))
          (for/list ([t ts])
            (let* ([id_ (car t)]
                   [pos_id (cadr t)]
                   [pos_ (send track get-segment pos_id)]
                   [speed_ (caddr t)]
                   [train (find-train trains id_)])
              (send train set-position! pos_)
              (send train set-speed! speed_))))
        (sleep 3)
        (loop (send requester request "get-trains")))))
))
