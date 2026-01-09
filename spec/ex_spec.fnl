(import-macros {: context : specify} :busted)

(context "lol"
         (specify "xd 1" (assert.truthy 1))
         (specify "xd 2" (assert.truthy :a))
         (specify "xd 3" (assert.truthy nil))
         (specify "xd 4" (assert.truthy {})))
