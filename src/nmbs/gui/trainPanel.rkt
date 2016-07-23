#lang racket/gui
;Author Koen Bellemans

(provide trainPanel%)

(define trainPanel%
  (class vertical-panel%
    (super-new)
    ;variable inititalization
    ;(init-field add-train goto)
    ;creat the add-train button
    (define (make-train)(println "make-train"))
    (define add-train-button (new button% [label "add-train"][parent this]))))
