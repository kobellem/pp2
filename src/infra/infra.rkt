#lang racket
;Author Koen Bellemans

(require "server.rkt" "requestHandler.rkt")

(define (infra)
  ;Create TCP server
  (define server (new server% [port 3000]))
  (define requestHandler (new requestHandler%))
  (send server listen (lambda (in out)
    (send requestHandler handle-request in out))))

(infra)
