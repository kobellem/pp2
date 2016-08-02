#lang racket/gui
;Author Koen Bellemans

(require racket/set)
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
              (send train-pane update! seg speed)
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

(define trainPane%
  (class vertical-pane%
    (super-new)
    (public get-id update!)
    ;variable initialization
    (init-field id goto)
    (define id-message (new message% [label (string-append "Train: " id)][parent this]))
    (define pos-message (new message% [label "wait for update"][parent this]))
    (define speed-message (new message% [label "wait for update"][parent this]))
    ;add the goto button
    (define (go button event)
      (let ([dest (send goto-field get-value)])
        (if (string->number dest)
          (goto id (string->number dest))
          (error "destination must be a number"))))
    (define goto-field (new text-field% [label "destination:"][parent this]))
    (define goto-button (new button% [label "go"][parent this][callback go]))
    ;public methods
    (define (get-id) id)
    (define (update! seg speed)
      (send pos-message set-label (string-append "Position: " (number->string (send seg get-id))))
      (send speed-message set-label (string-append "Speed: " (number->string speed))))))
