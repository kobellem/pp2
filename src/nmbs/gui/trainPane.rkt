#lang racket/gui
;Author Koen Bellemans

(provide trainPane%)

(define trainPane%
  (class vertical-pane%
    (super-new)
    (public get-id update!)
    ;variable initialization
    (init-field id goto)
    (define id-message (new message% [label (string-append "Train: " id)][parent this]))
    (define pos-message (new message% [label "wait for update"][parent this]))
    (define speed-message (new message% [label "wait for update"][parent this]))
    ;public methods
    (define (get-id) id)
    (define (update! seg speed)
      (send pos-message set-label (string-append "Position: " (number->string (send seg get-id))))
      (send speed-message set-label (string-append "Speed: " (number->string speed))))))
