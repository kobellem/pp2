#lang racket
;Author Koen Bellemans

(require "gui/gui.rkt" "tcpRequester.rkt")

(define (nmbs)
  (define tcpRequester (new tcpRequester% [host "localhost"][port 3000]))
  ;create gui
  (define gui (new gui% [callbacks (make-callbacks tcpRequester)]))
  ;(send tcpRequester request "add-train" (list "1" 5))
  ;(print (send tcpRequester request-serialized "get-trains"))
)

(define (make-callbacks tcpRequester)
  (list
    ;get-track callback
    (cons
      'get-track
      (lambda ()
        (send tcpRequester request-serialized "get-track")))))

(nmbs)
