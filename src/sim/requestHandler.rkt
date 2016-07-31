#lang racket
;Author Koen Bellemans

(require racket/serialize)
(provide requestHandler%)

(define requestHandler%
  (class object%
    (super-new)
    (public handle-request)
    ;variable initialization
    (init-field controller)
    ;public methods
    (define (handle-request in out)
      (let ([req (read in)])
        (println (string-append "Request: " req))
        (cond
          [(string=? req "init")(init in out)]
          [(string=? req "add-train")(add-train in out)]
          [(string=? req "get-trains")(get-trains out)]
          [(string=? req "set-speed")(set-speed in out)]
          [else (unknown req out)])
        (flush-output out)))
    ;private methods
    (define (init in out)
      (send controller init (deserialize (car (read in))))
      (write "Track initialized" out))
    (define (add-train in out)
      (let* ([args (read in)]
             [id (car args)]
             [pos (cdr args)])
        (send controller add-train id pos))
      (write "train added" out))
    (define (get-trains out)
      (write (send controller get-trains) out))
    (define (set-speed in out)
      (let* ([args (read in)]
             [id (car args)]
             [speed (cadr args)]
             [dir (caddr args)])
        (send controller set-speed! id speed dir)))
    (define (unknown req out)
      (write (string-append "Unknown request: " req) out))))
