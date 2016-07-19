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
    (define (request msg) (send msg))
    (define (request-serialized msg) (deserialize (send msg)))
    ;private methods
    (define (send msg)
      (define-values (in out) (tcp-connect host port))
      (write msg out)
      (flush-output out)
      (let ([answer (read in)])
        (close-input-port in)
        (close-output-port out)
        answer))))
