#lang racket
;Author Koen Bellemans

(require "gui/gui.rkt" "tcpRequester.rkt")

(define (nmbs)
  (define tcpRequester (new tcpRequester% [host "localhost"][port 3000]))
  ;create gui
  (define gui (new gui% [x 1024][y 512][callbacks (make-callbacks tcpRequester)]))
  (send tcpRequester request "add-train" (list "5" 3))
)

(define (make-callbacks tcpRequester)
  (list
    ;get-track callback
    (cons
      'get-track
      (lambda ()
        (send tcpRequester request-serialized "get-track")))))

(nmbs)
