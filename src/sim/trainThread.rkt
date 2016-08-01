#lang racket
;Author Koen Bellemans

(provide trainThread%)

(define trainThread%
  (class object%
  (super-new)
  (public  get-id set-speed! get-speed get-position)
  ;variable initialization
  (init-field track id position)
  (define speed 0)
  (define dir #t)
  ;public methods
  (define (get-id) id)
  (define (set-speed! new-speed new-dir)
    (set! speed new-speed)
    (set! dir new-dir)
    (if (eq? new-speed 0)
      (thread-suspend t)
      (thread-resume t)))
  (define (get-speed) speed)
  (define (get-position) position)
  ;the train thread
  (define t (thread (lambda ()
    (let loop ()
      (if (eq? speed 0)
        (sleep 10)
        (let ([delta (/ (send position get-length) speed)])
          (sleep delta)
          (let* ([nodes (send position get-nodes)]
                 [next-node (if dir (cdr nodes)(car nodes))]
                 [segments (send next-node get-segments)]
                 [next-position (if (equal? (car segments)(send position get-id))
                   (cdr segments)
                   (car segments))])
            (set! position (send track get-segment next-position)))))
      (loop)))))
))
