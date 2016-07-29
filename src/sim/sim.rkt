#lang racket
;Author Koen Bellemans

(require "../lib/tcp/server.rkt" "requestHandler.rkt" "simHandler.rkt")

(define (sim)
  (define track #f)
  ;create the simHandler
  (define simHandler (new simHandler%))
  ;create TCP server
  (define server (new server% [port 3001]))
  (define requestHandler (new requestHandler% [simHandler simHandler]))
  (define server-thread
    (thread
      (send server listen (lambda (in out)
        (send requestHandler handle-request in out)))))
  (println "ok"))

(sim)
