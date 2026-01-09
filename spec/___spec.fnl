(import-macros {: desc : spec} :busted)
(local __ (require :__))

(desc "util library"
  (spec "dig"
    (assert.same 1
                 (__.dig {:a {:b 1}} :a :b)))
  (spec "assign"
    (assert.same {:a 1 :b 2}
                 (__.assign {} {:a 1} {:b 2}))
    (assert.same {:a 1 :b 2}
                 (__.assign {:a 2} {:a 1} {:b 2}))))
