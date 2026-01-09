(local c (require :class))
(local MaybeClass (c.class :MaybeClass))

(fn MaybeClass.initialize [self nilable]
  (set self.val nilable))

(fn MaybeClass.or [self fallback]
  (if (= nil self.val) fallback self.val))

(fn [nilable] (MaybeClass:new nilable))
