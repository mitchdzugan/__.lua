(local _ (require :core))
(local c (require :class))

;; module impl

(local MapClass (c.class :MapClass))

(fn MapClass.initialize [self kvs opts]
  (set self.data {})
  (set self.opts (or opts {}))
  (each [_ [k v] (pairs (or kvs []))]
    (self:set k v)))

(fn MapClass.to-key [self k]
  ((or (. self :opts :to-key) #$) k))

(fn MapClass.set [self k v]
  (tset self.data (self:to-key k) {: k : v}))

(fn MapClass.get [self k]
  (. (or (. self.data (self:to-key k)) {}) :v))

(fn MapClass.has? [self k]
  (_.any? (. self.data (self:to-key k))))

(fn MapClass.rm [self k]
  (tset self.data (self:to-key k) nil))

(fn MapClass.ikeys [self]
  (ipairs (icollect [_ {: k} (pairs self.data)] k)))

(fn MapClass.ivals [self]
  (ipairs (icollect [_ {: v} (pairs self.data)] v)))

(fn MapClass.ientries [self]
  (ipairs (icollect [_ {: k : v} (pairs self.data)] [k v])))

;; module return

(fn [...] (MapClass:new ...))
