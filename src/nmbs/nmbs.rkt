#lang racket
;Author Koen Bellemans

(require "gui/gui.rkt" "tcpRequester.rkt")

(define (nmbs)
  (define tcpRequester (new tcpRequester% [host "localhost"][port 3000]))
  (define track (send tcpRequester request-serialized "get-track"))
  ;create gui
  (define gui (new gui% [track track]))
  (print "ok"))

(nmbs)
