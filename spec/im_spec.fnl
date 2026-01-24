(import-macros {: desc : spec} :busted)
(import-macros _ :__)

(macro tst [n expected initial & pipeline]
  (local n-im (.. n ":im?"))
  `(let [init# ,initial
         cloned# ((. (require :__) :im :clone) init#)]
     (spec ,n
       (assert.same ,expected (-> init# ,(unpack pipeline))))
     (spec ,n-im
       (assert.same cloned# init#))))

(desc "immutable table library"
  (spec :clone
    (local s1 {:a 1})
    (local c1 (_.im.clone s1))
    (assert.same s1 c1)
    (assert.are_not.equals s1 c1)
    (set c1.d 2)
    (assert.are_not.same s1 c1)
    (local s2 {:a {:b 1}})
    (local c2 (_.im.deep-clone s2))
    (assert.same s2.a c2.a)
    (assert.are_not.equals s2.a c2.a)
    (set c2.a.d 2)
    (assert.are_not.same s2.a c2.a))
  (spec :list?
    (assert.is_false (_.im.list? [1 2 3]))
    (assert.is_true (_.im.list? (_.im.list 1 2 3)))
    (assert.is_true (_.im.list? (_.im.push (_.im.list 1 2 3) 4))))
  (spec :list (assert.same [1 2 3] (_.im.list 1 2 3)))
  (tst :push [1 2 3] [] (_.im.push 1) (_.im.push 2) (_.im.push 3))
  (tst :concat [1 2 3] [] (_.im.concat [1]) (_.im.concat [2 3]))
  (tst :concat* [1 2 3] [] (_.im.concat [1] [2 3]))
  (tst :get 1 {:a 1} (_.im.get :a 2))
  (tst :get 2 {:a 1} (_.im.get :b 2))
  (tst :get-in 1 {:a {:b 1}} (_.im.get-in [:a :b] 2))
  (tst :get-in 2 {:a {:b 1}} (_.im.get-in [:a :c] 2))
  (tst :merge {:a 1 :b 2 :c 3} {} (_.im.merge {:a 1 :c 1} {:b 2} {:c 3}))
  (tst :assoc {:a 1} {} (_.im.assoc :a 1))
  (tst :assoc-in {:a {:b 2}} {} (_.im.assoc-in [:a :b] 2))
  (tst :update {:a 2} {:a 1} (_.im.update :a #(_.inc $1)))
  (tst :update-in {:a {:b 2}} {:a {:b 1}} (_.im.update-in [:a :b] #(_.inc $1))))
