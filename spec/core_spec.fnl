(import-macros {: desc : spec} :busted)
(import-macros _ :__-macros)

(desc "util library"
  (spec "dig"
    (assert.same 1
                 (_.dig {:a {:b 1}} [:a :b])))
  (spec "assign"
    (assert.same {:a 1 :b 2}
                 (_.assign {} {:a 1} {:b 2}))
    (assert.same {:a 1 :b 2}
                 (_.assign {:a 2} {:a 1} {:b 2})))
  (->> (_.tail [0 0]
               (fn [recur i s]
                 (if (>= i 10) s (recur (+ 1 i) (+ i s)))))
       (assert.same 45)
       (spec "tail"))
  (->> (_.ival-list (ipairs [:a :b :c :d :e]))
       (assert.same [:a :b :c  :d :e])
       (spec "ival-list"))
  (->> (_.ilist (ipairs [:a :b :c :d :e]))
       (assert.same [1 2 3 4 5])
       (spec "ilist"))
  (->> (_.ilist (_.ivals (ipairs [:a :b :c :d :e])))
       (assert.same [:a :b :c  :d :e])
       (spec "ivals"))
  (->> (ipairs [10 11 12 13 14])
       (_.imap-vals #(_.inc $2))
       (_.imap-vals #(_.dec $2))
       (_.imap-vals #(_.inc $2))
       _.ival-list
       (assert.same [11 12 13 14 15])
       (spec "imap"))
  (->> (_.tvals [10 11 12 13 14])
       (_.imap #(_.inc $1))
       (_.imap #(_.dec $1))
       (_.imap #(_.inc $1))
       _.ilist
       (assert.same [11 12 13 14 15])
       (spec "tvals"))
  (->> (let [n (_.co-wrap (fn [] (_.co-yield 1) 2))]
         [(n) (n)])
       (assert.same [{:val 1 :final? false} {:val 2 :final? true}])
       (spec "co-wrap")))
