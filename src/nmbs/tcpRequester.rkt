#lang racket
;Author Koen Bellemans

(require racket/tcp racket/serialize)
(provide tcpRequester%)

(define tcpRequester%
  (class object%
    (super-new)
    (public request)
    ;variable initialization
    (init-field host)
    (init-field port)
    ;public methods
    (define (request msg)
      (define-values (in out) (tcp-connect host port))
      (write msg out)
      (flush-output out)
      (let ([answer (read in)])
        (close-input-port in)
        (close-output-port out)
        answer))))
