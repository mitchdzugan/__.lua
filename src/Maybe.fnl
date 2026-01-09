(local _ (require :core))
(local c (require :class))

;; module impl

(local MaybeClass (c.class :MaybeClass))

(fn MaybeClass.initialize [self nilable]
  (set self.val nilable))

(fn MaybeClass.or [self fallback]
  (if (_.nil? self.val) fallback self.val))

(fn MaybeClass.value [self]
  (self:or))

(fn MaybeClass.case [self on-some on-nothing]
  (if (_.nil? self.val) (on-nothing) (on-some self.val)))

;; module return

(fn [nilable] (MaybeClass:new nilable))
