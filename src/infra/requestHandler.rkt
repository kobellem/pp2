#lang racket
;Author Koen Bellemans

(require racket/serialize)
(provide requestHandler%)

(define requestHandler%
  (class object%
    (super-new)
    (public handle-request)
    ;variable initialization
    (init-field track trainHandler)
    (init)
    ;public methods
    (define (handle-request in out)
      (let ([req (read in)])
        (println (string-append "Request: " req))
        (cond
          [(string=? req "test")(test out)]
          [(string=? req "get-track")(get-track out)]
          [(string=? req "add-train")(add-train in out)]
          [(string=? req "get-trains")(get-trains out)]
          [else (unknown req out)])
        (flush-output out)))
    ;private methods
    (define (test out)
      (write "ok" out))
    (define (get-track out)
      (write (serialize track) out))
    (define (add-train in out)
      (let* ([args (read in)]
             [id (car args)]
             [seg-id (cadr args)]
             [pos (send track get-segment seg-id)])
        (send trainHandler add-train id pos)
        (write (string-append "Train " (number->string id)) out)))
    (define (get-trains out)
      (write (serialize (send trainHandler get-trains)) out))
    (define (unknown req out)
      (write (string-append "Unknown request: " req) out)
      (flush-output out))))
