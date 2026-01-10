(local _ (require :core))
(local c (require :class))
(local Maybe (require :Maybe))

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

(fn MapClass.ientries [self]
  (->> (_.tvals self.data)
       (_.imap (fn [{: k : v}] [k v]))))

(fn MapClass.imkeys [self]
  (->> (self:ientries)
       (_.imap (fn [[k]] (Maybe k)))))

(fn MapClass.imvals [self]
  (->> (self:ientries)
       (_.imap (fn [[_ v]] (Maybe v)))))

;; module return

(fn [...] (MapClass:new ...))
