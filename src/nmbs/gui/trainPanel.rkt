#lang racket/gui
;Author Koen Bellemans

(require racket/set)
(require "trainPane.rkt")
(provide trainPanel%)

(define trainPanel%
  (class vertical-panel%
    (super-new)
    (public list-trains)
    ;variable inititalization
    (init-field add-train get-trains goto)
    (define train-panes '())
    ;make the add-train pane
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
    ;list the current trains
    (define trains-pane (new vertical-pane% [parent this][alignment '(center top)]))
    (define (list-trains)
      (let ([trains (get-trains)])
        (for/mutable-set ([train trains])
          (let* ([id (send train get-id)]
                 [seg (send train get-position)]
                 [speed (send train get-speed)]
                 [train-pane (find-train-pane id)])
            (if train-pane
              (send train-pane update! pos speed)
              (set! train-panes (cons
                (new trainPane%
                  [parent trains-pane]
                  [id id]
                  [goto goto])
                  train-panes)))))))
    (define (find-train-pane id)
      (let loop ([lst train-panes])
        (if (empty? lst)
          #f
          (if (string=? (send (car lst) get-id) id)
            (car lst)
            (loop (cdr lst))))))))
