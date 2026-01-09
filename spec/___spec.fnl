(import-macros {: desc : spec} :busted)
(local __ (require :__))

(desc "util library"
  (spec "dig"
    (assert.same 1
                 (__.dig {:a {:b 1}} [:a :b])))
  (spec "assign"
    (assert.same {:a 1 :b 2}
                 (__.assign {} {:a 1} {:b 2}))
    (assert.same {:a 1 :b 2}
                 (__.assign {:a 2} {:a 1} {:b 2})))
  (->> (let [n (__.co-wrap (fn [] (__.co-yield 1) 2))]
         [(n) (n)])
       (assert.same [{:val 1 :final? false} {:val 2 :final? true}])
       (spec "co-wrap")))
