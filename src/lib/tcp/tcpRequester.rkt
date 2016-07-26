#lang racket
;Author Koen Bellemans

(require racket/tcp racket/serialize)
(provide tcpRequester%)

(define tcpRequester%
  (class object%
    (super-new)
    (public request request-serialized)
    ;variable initialization
    (init-field host)
    (init-field port)
    ;public methods
    (define (request msg [args #f])(send msg args))
    (define (request-serialized msg [args #f])(deserialize (send msg args)))
    ;private methods
    (define (send msg args)
      (define-values (in out)(tcp-connect host port))
      (write msg out)
      (when args (write args out))
      (flush-output out)
      (let ([answer (read in)])
        (close-input-port in)
        (close-output-port out)
        answer))))
