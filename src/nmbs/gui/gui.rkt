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
                 [c1 (send node1 get-coordinates)]
                 [c2 (send node2 get-coordinates)])
            (send dc draw-line (car c1) (cdr c1) (car c2) (cdr c2)))))))
    ;initialization
    (make-window 1024 512)
    (sleep/yield 1)
    (draw-track)))
