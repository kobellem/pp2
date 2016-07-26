#lang racket
;Author Koen Bellemans

(require racket/serialize)
(provide sim-requestHandler%)

(define sim-requestHandler%
  (class object%
    (super-new)
    (public handle-request)
    ;variable initialization
    (init-field set-track!)
    ;public methods
    (define (handle-request in out)
      (let ([req (read in)])
        (println (string-append "Request: " req))
        (cond
          [(string=? req "init")(init in out)]
          [else (unknown req out)])
        (flush-output out)))
    ;private methods
    (define (init in out)
      (set-track! (deserialize (read in)))
      (write "Track initialized" out))
    (define (unknown req out)
      (write (string-append "Unknown request: " req) out))))
