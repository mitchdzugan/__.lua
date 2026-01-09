(import-macros {: desc : spec} :busted)
(local Map (require :Map))

(desc "Map"
  (spec "get"
    (assert.same 1 (: (Map [[:a 1]]) :get :a))
    (assert.same nil (: (Map) :get :a))))
