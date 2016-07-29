#lang racket
;Author Koen Bellemans

(require racket/serialize)
(provide requestHandler%)

(define requestHandler%
  (class object%
    (super-new)
    (public handle-request)
    ;variable initialization
    (init-field simHandler)
    ;public methods
    (define (handle-request in out)
      (let ([req (read in)])
        (println (string-append "Request: " req))
        (cond
          [(string=? req "init")(init in out)]
          [(string=? req "add-train")(add-train in out)]
          [(string=? req "get-trains")(get-trains out)]
          [else (unknown req out)])
        (flush-output out)))
    ;private methods
    (define (init in out)
      (send simHandler init (deserialize (car (read in))))
      (write "Track initialized" out))
    (define (add-train in out)
      (let* ([args (read in)]
             [id (car args)]
             [pos (cdr args)])
        (send simHandler add-train id pos))
      (write "train added" out))
    (define (get-trains out)
      (write (serialize (send simHandler get-trains)) out))
    (define (unknown req out)
      (write (string-append "Unknown request: " req) out))))
