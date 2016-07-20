#lang racket
;Author Koen Bellemans

(require "gui/gui.rkt" "tcpRequester.rkt")

(define (nmbs)
  ;(define tcpRequester (new tcpRequester% [host "localhost"][port 3000]))
  ;(define track (send tcpRequester request-serialized "get-track"))
  ;(print track))
  (print "test")
  ;create gui
  (define gui (new gui% [track #f])))

(nmbs)
