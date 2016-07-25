#lang racket/gui
;Author Koen Bellemans

(require "trackPanel.rkt" "trainPanel.rkt")
(provide gui%)

(define gui%
  (class object%
    (super-new)
    ;variable initialization
    (init-field x y callbacks)
    (define window (new frame% [label "pp2"][width x][height y]))
    (define main-panel (new horizontal-panel% [parent window][enabled #t]))
    (define trackPanel (new trackPanel% 
      [parent main-panel]
      [enabled #t]
      [min-width (* (/ x 4) 3)]
      [get-track (find-callback callbacks 'get-track)]))
    (define trainPanel (new trainPanel% 
      [parent main-panel]
      [enabled #t]
      [alignment '(center top)]
      [add-train (find-callback callbacks 'add-train)]
      [get-trains (find-callback callbacks 'get-trains)]
      [goto (find-callback callbacks 'goto)]))
    ;private methods
    (define (refresh)
      (send trackPanel draw-track)
      (send trainPanel list-trains))
    (define (make-window x y)
      (send window show #t))
    ;initialization
    (make-window 1024 512)
    ;start the gui thread
    (thread (lambda () 
      (let loop ()
        (refresh)
        (sleep/yield 3)
        (loop))))))

(define (find-callback callbacks tag)
  (let loop ([lst callbacks])
    (if(empty? lst)
      #f
      (if (equal? (caar lst) tag)
        (cdar lst)
        (loop (cdr lst))))))
