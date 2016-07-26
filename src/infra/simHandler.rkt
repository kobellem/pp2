#lang racket
;Author Koen Bellemans

(require racket/serialize)
(require "../lib/tcp/tcpRequester.rkt")
(provide simHandler%)

(define simHandler%
  (class object%
    (super-new)
    (public init)
    ;variable initalization
    (init host port)
    (define tcpRequester (new tcpRequester% [host host][port port]))
    ;public methods
    (define (init track)
      (send tcpRequester request "init" (list (serialize track))))
))
