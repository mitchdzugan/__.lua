(import-macros {: desc : spec} :busted)
(local _ (require :core))
(local Maybe (require :Maybe))
(local Map (require :Map))

(desc "Map"
  (spec "get"
    (assert.same 1 (: (Map [[:a 1]]) :get :a))
    (assert.same nil (: (Map) :get :a)))
  (spec "imvals"
    (assert.same [[:a nil]] (_.ilist (: (Map [[:a nil]]) :ientries)))
    (assert.same [(Maybe nil)] (_.ilist (: (Map [[:a nil]]) :imvals)))
    (assert.same [(Maybe :a)] (_.ilist (: (Map [[:a nil]]) :imkeys)))))
