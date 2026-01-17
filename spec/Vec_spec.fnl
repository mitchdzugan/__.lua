(import-macros {: desc : spec} :busted)
(local _ (require :core))
(local Maybe (require :Maybe))
(local Vec (require :Vec))

(desc "Vec"
  (spec "Vec"
    (assert.same [(Maybe :a) (Maybe :b) (Maybe :c)]
                 (_.ilist (: (Vec [:a :b :c]) :imvals)))
    (assert.same [1 2 3] (_.ilist (: (Vec [:a :b :c]) :imkeys)))))
