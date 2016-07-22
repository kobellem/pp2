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
  (define (set-position! pos)(set! position pos))
  (define (get-position) position)
  (define (set-speed! new-speed)(set! speed new-speed))
  (define (get-speed) speed)
  (define (set-route! new-route)
    (if (eq? (car new-route) position)
      (error 'train "First route position must equal current position")
      (set! route new-route)))
  (define (get-route) route)
  ;externalizable interface
  (define/public (externalize) (list id position speed))
  (define/public (internalize lst)
    (set-id! (car lst))
    (set-position! (cadr lst))
    (set-speed! (caddr lst))))
