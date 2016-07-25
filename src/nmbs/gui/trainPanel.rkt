#lang racket/gui
;Author Koen Bellemans

(provide trainPanel%)

(define trainPanel%
  (class vertical-panel%
    (super-new)
    ;variable inititalization
    (init-field add-train goto)
    (define add-train-pane (new vertical-pane% [parent this]))
    (define (make-train button event)
      (let ([id (send add-train-id get-value)]
            [pos (send add-train-pos get-value)])
        (if (string->number pos)
          (add-train id (string->number pos))
          (error "train-position must be a number")))
      (send add-train-id set-value "")
      (send add-train-pos set-value ""))
    (define add-train-id (new text-field% 
      [label "id"]
      [parent add-train-pane]))
    (define add-train-pos (new text-field%
      [label "position"]
      [parent add-train-pane]))
    (define add-train-button (new button% 
      [label "add-train"]
      [parent add-train-pane]
      [callback make-train]))
))
