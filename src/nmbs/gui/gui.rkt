#lang racket/gui
;Author Koen Bellemans

;(require racket/gui/base)
(provide gui%)

(define gui%
  (class object%
    (super-new)
    (public refresh)
    ;variable initialization
    (init-field track)
    (define canvas #f)
    ;publice methods
    (define (refresh)
      (print "refresh"))
    ;private methods
    (define (make-window x y)
      (define window (new frame% [label "pp2"][width x][height y]))
      (set! canvas (new canvas% [parent window]))
      (send window show #t))
    (define (draw-track)
      (let ([dc (send canvas get-dc)])
        (send track for-each-segment (lambda (seg)
          (let* ([nodes (send seg get-nodes)]
                 [node1 (car nodes)]
                 [node2 (cdr nodes)]
                 [x1 (send node1 get-x)]
                 [y1 (send node1 get-y)]
                 [x2 (send node2 get-x)]
                 [y2 (send node2 get-y)])
            (send dc draw-line x1 y1 x2 y2))))))
    ;initialization
    (make-window 1024 512)
    (sleep/yield 1)
    (draw-track)))
