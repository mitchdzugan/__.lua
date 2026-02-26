(import-macros {: desc : spec} :busted)
(import-macros __ :__)

(__.module
 (local Class1 (_.class :Class1))
 (local Class2 (_.class :Class2))
 (local SClass1 (Class1:subclass :SClass1))
 (desc "util library"
   (spec "_.||"
     (assert.same 1
       (_.|| {:a #$1} :a & 1)))
   (spec "_.|%"
     (assert.same "2345" (_.|% "12345" &sub 2)))
   (spec "dig"
     (assert.same 1
       (_.dig {:a {:b 1}} [:a :b])))
   (spec "subclass?"
     (assert.same true (_.subclass? (Class1:new)))
     (assert.same true (_.subclass? (Class2:new)))
     (assert.same true (_.subclass? (SClass1:new)))
     (assert.same true (_.subclass? (SClass1:new) Class1))
     (assert.same true (_.subclass? (SClass1:new) SClass1))
     (assert.same false (_.subclass? (SClass1:new) Class2)))
   (spec "assign"
     (assert.same {:a 1 :b 2} (_.assign {} {:a 1} {:b 2}))
     (assert.same {:a 1 :b 2} (_.assign {:a 2} {:a 1} {:b 2})))
   (->> (_.tail$ [[i s] 0 0]
          (if (>= i 10) s ($1 (+ 1 i) (+ i s))))
        (assert.same 45)
        (spec "tail"))
   (->> (_.ival-list (ipairs [:a :b :c :d :e]))
        (assert.same [:a :b :c :d :e])
        (spec "ival-list"))
   (->> (_.ilist (ipairs [:a :b :c :d :e]))
        (assert.same [1 2 3 4 5])
        (spec "ilist"))
   (->> (_.ilist (_.ivals (ipairs [:a :b :c :d :e])))
        (assert.same [:a :b :c :d :e])
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
        (spec "co-wrap"))))
