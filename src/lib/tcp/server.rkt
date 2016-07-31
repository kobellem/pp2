#lang racket
;Author Koen Bellemans

(require racket/tcp)
(provide server%)

(define server%
  (class object%
    (super-new)
    (public listen)
    ;initialization
    (init-field port)
    (define listener (tcp-listen port))
    ;public methods
    (define (listen reader)
      (println (string-append "Server now listening on port " (number->string port)))
      (lambda ()
        (let loop ()
          (define-values (in out) (tcp-accept listener))
          (reader in out)
          (close-input-port in)
          (close-output-port out)
          ;give control to other threads
          (sleep 0)
          (loop))))
))
