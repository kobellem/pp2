#lang racket
;Author Koen Bellemans

(require "tcpRequester.rkt")

(define (nmbs)
  (define tcpRequester (new tcpRequester% [host "localhost"][port 3000]))
  (define track (send tcpRequester request-serialized "get-track"))
  (print track))

(nmbs)
