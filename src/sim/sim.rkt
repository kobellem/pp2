#lang racket
;Author Koen Bellemans

(require "../lib/tcp/server.rkt" "requestHandler.rkt")

(define (sim)
  (define track #f)
  ;create TCP server
  (define server (new server% [port 3001]))
  (define requestHandler (new requestHandler%
    [set-track! (lambda (t) (set! track t))]))
  (define server-thread
    (thread
      (send server listen (lambda (in out)
        (send requestHandler handle-request in out)))))
  (println "ok"))

(sim)
