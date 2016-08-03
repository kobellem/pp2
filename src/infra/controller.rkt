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
    (define (start train dir)(send requester request "set-speed" (list (send train get-id) 10 dir)))
    ;public methods
    (define (add-train id_ pos)
      (set-add! trains (make-train id_ (send track get-segment pos)))
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
            (let-values ([(route dir)(calculate-route track train pos #f)])
              (for/list ([seg (cdr route)])
                (send seg set-state! 'reserved))
              (send train set-route! route)
              ;start the train
              (start train dir)))
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
    (define (calculate-route track train to reversed?)
      (define queue (make-queue))
      (define visited '(#f))
      (let loop ([route '()]
                 [from (position train)])
        (println "looping")
        (if (equal? from to)
          (values (append route (list from)) (not reversed?))
          (let* ([node (if reversed? 
                           (car (send from get-nodes))
                           (cdr (send from get-nodes)))]
                 [seg-ids (send node get-segments)]
                 [alt-seg-ids (send node get-alt-segments)]
                 [pos-id (send from get-id)]
                 [next-pos (send track get-segment (next-seg pos-id seg-ids))]
                 [alt-next-pos (if (and alt-seg-ids (member pos-id alt-seg-ids))
                                 (send track get-segment (next-seg pos-id alt-seg-ids))
                                 #f)])
            (println (next-seg pos-id seg-ids))
            (when (not (member next-pos visited))
              (begin
                (set! visited (append visited (list next-pos)))
                (enqueue! queue (lambda () (loop (append route (list from)) next-pos)))))
            (when (and alt-seg-ids (not (member alt-next-pos visited)))
              (begin
                (set! visited (append visited (list alt-next-pos)))
                (enqueue! queue (lambda () (loop (append route (list from)) alt-next-pos)))))
            (if (empty? queue)
              (if reversed?
                #f
                (calculate-route track train to #t))
              ((dequeue! queue)))))))
    (define (next-seg pos-id seg-ids)
      (if (eq? pos-id (car seg-ids))(cadr seg-ids)(car seg-ids)))
    ;update thread
    (define (update) (lambda ()
      (let loop ([ts (send requester request "get-trains")])
        (println "updating")
        (when (not (empty? ts))
          (for/list ([t ts])
            (let* ([id_ (car t)]
                   [pos_id (cadr t)]
                   [pos_ (send track get-segment pos_id)]
                   [speed_ (caddr t)]
                   [train (get-train id_)])
              (send train set-speed! speed_)
              (when (not (equal? pos_ (send train get-position)))
                (update-position train pos_)))))
        (sleep 3)
        (loop (send requester request "get-trains")))))
    (define (update-position train new-pos)
      (let* ([route (send train get-route)]
             [first-seg (car route)]
             [second-seg (cadr route)])
        (send first-seg set-state! 'free)
        (if (null? (cddr route))
          (begin 
            (stop train)
            (send train set-position! new-pos))
          (if (equal? new-pos second-seg)
            (send* train (set-position! new-pos)(set-route! (cdr route)))
            (update-position train new-pos)))))
))
