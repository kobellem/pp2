#lang racket
;Author Koen Bellemans

(require racket/serialize)
(require "load-track.rkt" "../lib/tcp/server.rkt" "../lib/tcp/tcpRequester.rkt" "requestHandler.rkt" "controller.rkt" "z21Handler.rkt")

(define (infra)
  ;load the testrack
  (define track (load-track))
  ;create and initialize simHandler
  ;TODO: option to work with z21 API
  ;(define simHandler (new tcpRequester% [host "localhost"][port 3001]))
  ;(send simHandler request "init" (list (serialize track)))
  (define z21Handler (new z21Handler%))
  (send z21Handler init)
  ;create controller
  (println "Creating controller")
  (define controller (new controller% [track track][requester z21Handler]))
  (define control-thread (thread (send controller update)))
  ;create TCP server
  (println "Creating server")
  (define server (new server% [port 3000]))
  (define requestHandler (new requestHandler% [track track][controller controller]))
  (define server-thread (thread (send server listen (lambda (in out)
                                  (send requestHandler handle-request in out)))))
  ;wait for threads to finish processing
  (thread-wait control-thread)
  (thread-wait server-thread)
)

(infra)
