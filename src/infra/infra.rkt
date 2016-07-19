#lang racket
;Author Koen Bellemans

(require "load-test-track.rkt" "server.rkt" "requestHandler.rkt")
(require "data/node.rkt")

(define (infra)
  ;load the testrack
  (define track (load-test-track))
  ;create TCP server
  (define server (new server% [port 3000]))
  (define requestHandler (new requestHandler% [track track]))
  (send server listen (lambda (in out)
    (send requestHandler handle-request in out))))

(infra)
