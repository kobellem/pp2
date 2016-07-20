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
    ;initialization
    (draw-window 512 256)
    ;publice methods
    (define (refresh)
      (print "refresh"))
    ;private methods
    (define (draw-window x y)
      (define window (new frame% [label "pp2"]))
      (send window show #t))))
