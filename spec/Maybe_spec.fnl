(import-macros {: desc : spec} :busted)
(local Maybe (require :Maybe))

(desc "Maybe"
  (spec "works"
    (assert.same 1 (: (Maybe 1) :or 2))
    (assert.same 2 (: (Maybe nil) :or 2))))
