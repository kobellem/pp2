#lang racket
;Author Koen Bellemans

(provide requestHandler%)

(define requestHandler%
  (class object%
    (super-new)
    (public handle-request)
    ;variable initialization
    (init)
    ;public methods
    (define (handle-request in out)
      (let ([req (read in)])
        (println (string-append "Request: " req))
        (cond
          [(string=? req "test")(test out)]
          [else (unknown req out)])))
    ;private methods
    (define (test out)
      (write "ok" out)
      (flush-output out))
    (define (unknown req out)
      (write (string-append "Unknown request: " req) out)
      (flush-output out))))
