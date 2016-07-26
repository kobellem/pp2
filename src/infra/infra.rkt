#lang racket
;Author Koen Bellemans

(require "load-test-track.rkt" "../lib/tcp/server.rkt" "requestHandler.rkt" "trainHandler.rkt" "simHandler.rkt")

(define (infra)
  ;load the testrack
  (define track (load-test-track))
  ;create trainHandler
  (define trainHandler (new trainHandler% [track track]))
  ;create and initialize simHandler
  ;TODO: option to work with z21 API
  (define simHandler (new simHandler% [host "localhost"][port 3001]))
  (send simHandler init (list track))
  ;create TCP server
  (define server (new server% [port 3000]))
  (define requestHandler (new requestHandler% [track track][trainHandler trainHandler]))
  (define server-thread 
    (thread 
      (send server listen (lambda (in out)
      (send requestHandler handle-request in out)))))
  (println "ok"))

(infra)
