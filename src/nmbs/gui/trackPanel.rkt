#lang racket/gui
;Author Koen Bellemans

(provide trackPanel%)

(define trackPanel%
  (class panel%
    (super-new)
    (public draw-track)
    (init-field get-track)
    ;variable initialization
    (define canvas (new canvas% [parent this]))
    (define red-pen (new pen% [color (make-color 255 0 0 1)]))
    (define green-pen (new pen% [color (make-color 0 255 0 1)]))
    (define blue-pen (new pen% [color (make-color 0 0 255 1)]))
    ;public methods
    (define (draw-track)
      (let* ([dc (send canvas get-dc)]
             [track (get-track)])
        (send track for-each-segment (lambda (seg)
          (let* ([nodes (send seg get-nodes)]
                 [node1 (car nodes)]
                 [node2 (cdr nodes)]
                 [x1 (*(send node1 get-x)3)]
                 [y1 (*(send node1 get-y)3)]
                 [x2 (*(send node2 get-x)3)]
                 [y2 (*(send node2 get-y)3)])
            ;set the right pen color
            (cond
              [(send seg state-eq? 'free)(send dc set-pen green-pen)]
              [(send seg state-eq? 'reserved)(send dc set-pen blue-pen)]
              [(send seg state-eq? 'occupied)(send dc set-pen red-pen)])
            (send dc draw-ellipse (- x1 5) (- y1 5) 10 10)
            (send dc draw-line x1 y1 x2 y2))))))))
