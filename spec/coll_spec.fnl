(import-macros {: desc : spec} :busted)
(import-macros __ :__)

(__.module
 (desc "coll"
   (spec "_.mapv"
     (assert.same [5 12 21 32 45]
       (_.mapv [5 6 7 8 9] #(* $1 $2))))
   (spec "_.filter"
     (assert.same [5 8]
       (_.filter [5 6 7 8 9] #(= 2 (% (* $1 $2) 3)))))
   (spec "_.reduce"
     (assert.same 120
       (_.reduce [5 6 7 8 9] #(+ $1 (* $2 $3)) 5)))))
