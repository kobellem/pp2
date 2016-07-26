#lang racket
;Author Koen Bellemans

(provide make-train)

(define (make-train id pos)
  (let ([train (new train%)])
    (send* train (set-id! id)(set-position! pos))
    train))

(define-serializable-class* train% object% (externalizable<%>)
  (super-new)
  (public set-id! get-id set-position! get-position set-speed! get-speed set-route! get-route)
  ;variable initialization
  (define id #f)
  (define position #f)
  (define speed 0)
  (define route '())
  ;public methods
  (define (set-id! id_)(set! id id_))
  (define (get-id) id)
  (define (set-position! pos)
    (set! position pos)
    (send pos set-state! 'occupied))
  (define (get-position) position)
  (define (set-speed! new-speed)(set! speed new-speed))
  (define (get-speed) speed)
  (define (set-route! new-route)
    (if (equal? (car new-route) position)
      (set! route new-route)
      (error 'train "First route position must equal current position")))
  (define (get-route) route)
  ;externalizable interface
  (define/public (externalize) (list id position speed))
  (define/public (internalize lst)
    (set-id! (car lst))
    (set-position! (cadr lst))
    (set-speed! (caddr lst)))
  ;train thread
  (define train-thread (thread (lambda ()
    (let loop ()
      (if (empty? route)
        (begin
          (set-speed! 0)
          (sleep 10))
        (begin
          (set-speed! 5)
          (let  ([delta (/ (send position get-length) speed)]
                 [next-position (if (null? (cdr route)) #f (cadr route))])
            (if (not next-position)
              (set! route '())
              (begin
                (send next-position set-state! 'reserved)
                (sleep delta)
                (send position set-state! 'free)
                (set-position! next-position)
                (set-route! (cdr route))
                (send position set-state! 'occupied))))))
      (loop))))))
