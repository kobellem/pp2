#lang racket
;Author Koen Bellemans

(require racket/serialize)
(require "load-track.rkt" "../lib/tcp/server.rkt" "../lib/tcp/tcpRequester.rkt" "requestHandler.rkt" "controller.rkt" "z21Handler.rkt")

(define (infra mode)
  ;load the testrack
  (define track (load-track))
  (define requester #f)
  (cond
    [(string=? mode "sim")
      (set! requester (new tcpRequester% [host "localhost"][port 3001]))
      (send requester request "init" (list (serialize track)))]
    [(string=? mode "z21")
      (set! requester (new z21Handler%))
      (send requester init)])
  ;create controller
  (println "Creating controller")
  (define controller (new controller% [track track][requester requester]))
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

(infra "sim")
