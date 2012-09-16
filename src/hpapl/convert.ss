(define (array->boolean a)
  (unless (boolean-array? a)
    (error 'array->boolean "invalid boolean array ~s" a))
  (not (zero? (scalar-value a))))

