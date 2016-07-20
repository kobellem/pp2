#lang racket
;Author Koen Bellemans

(require "data/track.rkt" "data/node.rkt")
(provide load-test-track)

(define (load-test-track)
  (define track (new track%))
  ;define nodes
  (define node1 (make-node 1 4 1))
  (define node2 (make-node 2 8 1))
  (define node3 (make-node 3 12 1))
  (define node4 (make-node 4 14 4))
  (define node5 (make-node 4 12 7))
  (define node6 (make-node 6 8 7))
  (define node7 (make-node 7 4 7))
  (define node8 (make-node 8 1 4))
  ;add segments to track
  (send track add-segment 1 node1 node2)
  (send track add-segment 2 node2 node3)
  (send track add-segment 3 node3 node4)
  (send track add-segment 4 node4 node5)
  (send track add-segment 5 node5 node6)
  (send track add-segment 6 node6 node7)
  (send track add-segment 7 node7 node8)
  (send track add-segment 8 node8 node1)
  track)
