(define keypad (map string->list
  '("     "
    " 123 "
    " 456 "
    " 789 "
    "     ")))
(define start-xy '(2 2))
(define (key-at x y)
  (list-ref (list-ref keypad y) x))

(define commands (list
  (list #\L (lambda (x y) (list (- x 1) y)))
  (list #\R (lambda (x y) (list (+ x 1) y)))
  (list #\U (lambda (x y) (list x (- y 1))))
  (list #\D (lambda (x y) (list x (+ y 1))))))
(define (command-for-step step)
  (list-ref (assq step commands) 1))
(define (run-step xy step)
  (let ((command (command-for-step step)))
    (let ((new-xy (apply command xy)))
      (if (char=? (apply key-at new-xy) #\ )
        xy
        new-xy))))
(define (run-steps xy steps)
  (if (null? steps)
    xy
    (let ((new-xy (run-step xy (car steps))))
      (run-steps new-xy (cdr steps)))))
(define (find-positions xy input-lists)
  (if (null? input-lists)
    '()
    (let ((new-xy (run-steps xy (car input-lists))))
      (cons new-xy (find-positions new-xy (cdr input-lists))))))
(define (find-digits start-xy input-lists)
  (map (lambda (xy) (apply key-at xy)) (find-positions start-xy input-lists)))

(define (read-until-eof p)
  (let ((line (read-line p)))
    (if (eof-object? line)
      '()
      (cons line (read-until-eof p)))))
(define read-input-lines (call-with-input-file "input" read-until-eof))
(define input-lists (map string->list read-input-lines))

(display (list->string (find-digits start-xy input-lists)))
(newline)
