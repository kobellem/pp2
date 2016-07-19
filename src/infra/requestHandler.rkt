#lang racket
;Author Koen Bellemans

(require racket/serialize)
(provide requestHandler%)

(define requestHandler%
  (class object%
    (super-new)
    (public handle-request)
    ;variable initialization
    (init-field track)
    (init)
    ;public methods
    (define (handle-request in out)
      (let ([req (read in)])
        (println (string-append "Request: " req))
        (cond
          [(string=? req "test")(test out)]
          [(string=? req "get-track")(get-track out)]
          [else (unknown req out)])))
    ;private methods
    (define (test out)
      (write "ok" out)
      (flush-output out))
    (define (get-track out)
      (write (serialize track) out)
      (flush-output out))
    (define (unknown req out)
      (write (string-append "Unknown request: " req) out)
      (flush-output out))))
