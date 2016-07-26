#lang racket
;Author Koen Bellemans

(require "gui/gui.rkt" "../lib/tcp/tcpRequester.rkt")

(define (nmbs)
  (define tcpRequester (new tcpRequester% [host "localhost"][port 3000]))
  ;create gui
  (define gui (new gui% [x 1024][y 512][callbacks (make-callbacks tcpRequester)]))
  (println "ok"))

(define (make-callbacks tcpRequester)
  (list
    ;get-track callback
    (cons
      'get-track
      (lambda ()
        (send tcpRequester request-serialized "get-track")))
    (cons
      'add-train
      (lambda (id pos)
        (send tcpRequester request "add-train" (list id pos))))
    (cons
      'get-trains
      (lambda ()
        (send tcpRequester request-serialized "get-trains")))))

(nmbs)
