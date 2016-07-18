#lang racket
;Author Koen Bellemans

(require racket/udp)
(require data/queue)
(provide setup listen read-messages)

(define request-queue (make-queue))

(define (setup)
  (begin
    (define sim (udp-open-socket #f #f))
    (udp-bind! sim "localhost" 21106)
    sim)
)

(define (listen socket . reader)
  (define (listener)
    (define request (make-bytes 65535))
    (udp-receive! socket request)
    (when (not (empty? reader))
      ((car reader) request)
    )
    (enqueue! request-queue request)
    (listener)
  )
  (thread listener)
  #t
)

(define (read-messages reader)
  (when (not (queue-empty? answer-queue))
    (begin
      (reader (dequeue! request-queue))
      (read-messages)
    )
  )
)
