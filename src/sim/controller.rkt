#lang racket
;Author Koen Bellemans

(require "trainThread.rkt")
(provide controller%)

(define controller%
  (class object%
    (super-new)
    (public init add-train get-trains set-speed! switch-state? switch get-positions)
    ;variable initialization
    (define track #f)
    (define switches '())
    (define trains '())
    ;abstraction
    (define (id t)(send t get-id))
    (define (pos t)(send t get-position))
    (define (speed t)(send t get-speed))
    ;public methods
    (define (init track_)
      (set! track track_)
      (send track for-each-node (lambda (node)
        (when (send node is-switch?)(set! switches (append switches (list node))))))
      (set! trains '()))
    (define (add-train id_ pos_)
      (let ([trainThread (new trainThread% [track track][id id_][position (send track get-segment pos_)])])
        (set! trains (cons trainThread trains))))
    (define (get-trains)
      (let ([answer '()])
        (for/list ([t trains])
          (set! answer (cons 
            (list (send t get-id)(send (send t get-position) get-id)(send t get-speed))
            answer)))
        answer))
    (define (set-speed! id_ new-speed dir)(send (find-train trains id_) set-speed! new-speed dir))
    (define (switch-state? id_)
      (let ([switch (findf (lambda (s) (eq? (send s get-id) id_)) switches)])
        (send switch is-switched?)))
    (define (switch id_ state)
      (let ([switch (findf (lambda (s) (eq? (send s get-id) id_)) switches)])
        (send switch set-switch-state! state)))
    (define (get-positions)
      (let ([answer '()])
        (for/list ([t trains])
          (set! answer (append 
            (list (send (send t get-position) get-id))
            answer)))
        answer))
    ;private methods
    (define (find-train lst id_)
      (if (empty? lst)
        #f
        (let ([current (car lst)])
          (if (string=? (id current) id_)
            current
            (find-train (cdr lst) id_)))))
))
