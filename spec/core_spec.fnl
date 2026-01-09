(import-macros {: desc : spec} :busted)
(local _ (require :core))

(desc "util library"
  (spec "dig"
    (assert.same 1
                 (_.dig {:a {:b 1}} [:a :b])))
  (spec "assign"
    (assert.same {:a 1 :b 2}
                 (_.assign {} {:a 1} {:b 2}))
    (assert.same {:a 1 :b 2}
                 (_.assign {:a 2} {:a 1} {:b 2})))
  (->> (let [n (_.co-wrap (fn [] (_.co-yield 1) 2))]
         [(n) (n)])
       (assert.same [{:val 1 :final? false} {:val 2 :final? true}])
       (spec "co-wrap")))
