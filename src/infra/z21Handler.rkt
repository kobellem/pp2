#lang racket
;Author Koen Bellemans

(require (prefix-in z21: "z21-API/Z21Socket.rkt"))
(require (prefix-in z21: "z21-API/Z21MessageSysStat.rkt"))
(require (prefix-in z21:"z21-API/Z21MessageSettings.rkt"))
(require (prefix-in z21:"z21-API/Z21MessageDriving.rkt"))
(require (prefix-in z21:"z21-API/Z21MessageLocation.rkt"))
(require (prefix-in z21:"z21-API/Z21MessageSwitches.rkt"))
(require (prefix-in z21:"z21-API/Z21MessageDecoderCV.rkt"))
(require (prefix-in z21: "z21-API/racket-bits-utils-master/bits.rkt"))
(require "MessageHandler.rkt")
(provide z21Handler%)

(define z21Handler%
  (class object%
    (super-new)
    (public init request)
    ;variable initialization
    (define socket #f)
    (define listenThread #f)
    ;public methods
    (define (init)
      (set! socket (z21:setup))
      (set! listenThread (make-listenThread)))
    (define (request req [args #f])
      (cond
        [(string=? req "get-positions")(get-positions)]
        [(string=? req "switch-state")(switch-state args)]
        [(string=? req "set-speed")(set-speed args)]
        [(string=? req "switch")(switch args)]
        [else "Unknown request"]))
    ;private methods
    (define (get-positions)
      (z21:send socket (z21:make-rmbus-get-data-msg "00"))
      (let* ([answer (get-answer)]
             [data (z21:get-rmbus-data answer)]
             [positions '()])
        (let outer-loop ([module (z21:get-module (car data))])
          (let inner-loop ([occupancies (z21:get-occupancies (car data))])
            (when (and (< module 3)(not (empty? occupancies)))
              (begin
                (set! positions (append positions (list (+ (* module 10)(car occupancies)))))
                (inner-loop (cdr occupancies)))))
          (set! data (cdr data))
          (when (not (empty? data))(outer-loop (z21:get-module (car data)))))
        positions))
    (define (set-speed args)
      (let* ([id (car args)]
             [speed (cadr args)]
             [dir (caddr args)]
             [msg (z21:make-set-loco-drive-msg id "00" 128 dir speed)])
        (z21:send socket msg)))
    (define (switch-state args)
      (let* ([id (car args)]
             [msg (z21:make-get-switch-info-msg (- id 1) "00")])
        (z21:send socket msg))
      (let ([answer (get-answer)])
        (if (eq? (z21:get-switch-info-position answer) 1) #t #f)))
    (define (switch args)
      (let* ([id (car args)]
             [state (cadr args)]
             [state-n (if state 1 2)]
             [msg (z21:make-set-switch-msg (z21:byte->hex-string (- id 1)) "00" true state-n)])
        (z21:send socket msg)))
    (define (get-answer)
      (let ([answer #f])
        (thread-send listenThread (lambda (a)(set! answer a)))
        (let l ()(when (not answer)(begin (sleep 0.2)(l))))
        answer))
    ;the listen thread for receiving answers from Z21
    (define (make-listenThread)
      (thread (lambda ()
        (define answer #f)
        (z21:listen socket (lambda (a)
          (when (z21:is-rmbus-datachanged-msg? a)
            (set! answer a))))
        (let loop ([cb (thread-receive)])
          (let inner-loop ()                ;check if the answer has been received already
            (if answer
              (cb answer)
              (begin
                (sleep 0.1)
                (inner-loop))))
        (set! answer #f)
        (loop (thread-receive))))))
))
