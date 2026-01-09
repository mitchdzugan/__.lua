(import-macros {: desc : spec} :busted)
(local Maybe (require :Maybe))

(desc "Maybe"
  (spec "value"
    (assert.same 1 (: (Maybe 1) :value))
    (assert.same nil (: (Maybe nil) :value)))
  (spec "or"
    (assert.same 1 (: (Maybe 1) :or 2))
    (assert.same 2 (: (Maybe nil) :or 2)))
  (spec "case"
    (assert.same 99 (: (Maybe 100) :case #(- $1 1) #:x))
    (assert.same :x (: (Maybe nil) :case #(- $1 1) #:x))))
