(define (array->boolean a)
  (unless (and (scalar-array? a)
               (or (= 0 (scalar-value a))
                   (= 1 (scalar-value a))))
    (error 'array->boolean "invalid boolean array ~s" a))
  (not (zero? (scalar-value a))))

