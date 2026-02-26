(import-macros {: desc : spec} :busted)
(import-macros __ :__)

(__.module
 (desc "coll"
   (spec :list?
     (assert.is_false (_.list? [1 2 3]))
     (assert.is_true (_.list? (&L 1 2 3)))
     (assert.is_true (_.list? (_.im.push (&L 1 2 3) 4))))
   (spec :list (assert.same [1 2 3] (&L 1 2 3)))
   (spec :object?
     (assert.is_false (_.object? {}))
     (assert.is_true (_.object? (&O)))
     (assert.is_true (_.object? (_.im.assoc (&O) 1 2))))
   (spec :object
     (assert.same {:a 1 2 :b} (&O [:a 1] [2 :b])))
   (spec "_.mapv"
     (assert.same [5 12 21 32 45]
       (_.mapv [5 6 7 8 9] #(* $1 $2))))
   (spec "_.filter"
     (assert.same [5 8]
       (_.filter [5 6 7 8 9] #(= 2 (% (* $1 $2) 3)))))
   (spec "_.reduce"
     (assert.same 120
       (_.reduce [5 6 7 8 9] #(+ $1 (* $2 $3)) 5)))))
