(import-macros {: desc : spec} :busted)
(local str (require :str))

(desc "str"
  (spec "__call"
    (assert.same "a2c" (str :a 2 :c)))
  (spec "split"
    (assert.same [:a :b :c] (str.split "a,b,c" ","))
    (assert.same [:a :b :c] (str.split "a \n b \tc")))
  (spec "trim"
    (assert.same "asd\t " (str.trim-l " \n asd\t "))
    (assert.same " \n asd" (str.trim-r " \n asd\t "))
    (assert.same "asd" (str.trim " \n asd\t ")))
  (spec "ends-with?"
    (assert.truthy (str.ends-with? "asdf" "df"))
    (assert.falsy (str.ends-with? "asdf" "df!")))
  (spec "starts-with?"
    (assert.truthy (str.starts-with? "asdf" "as"))
    (assert.falsy (str.starts-with? "asdf" "!as"))))
