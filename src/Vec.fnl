(local _ (require :core))
(local c (require :class))
(local Maybe (require :Maybe))

;; module impl

(local VecClass (c.class :VecClass))

(fn VecClass.initialize [self vals]
  (set self.data {})
  (set self.first-index 1)
  (set self.next-index 1)
  (set self.size 0)
  (each [_ v (ipairs (or vals []))]
    (self:push v)))

(fn VecClass.to-key [self k]
  ((or (. self :opts :to-key) #$) k))

(fn VecClass.push [self v]
  (tset self.data self.next-index v)
  (set self.size (_.inc self.size))
  (set self.next-index (_.inc self.next-index)))

(fn VecClass.imkeys [{: first-index : size}]
  (_.tvals (fcollect [i 1 size] (_.dec (+ i first-index)))))

(fn VecClass.imvals [self]
  (->> (self:imkeys)
       (_.imap (fn [k] (Maybe (. self.data k))))))

(comment (fn VecClass.set [self k v]
           (tset self.data (self:to-key k) {: k : v}))
  (fn VecClass.get [self k]
    (. (or (. self.data (self:to-key k)) {}) :v))

  (fn VecClass.has? [self k]
    (_.any? (. self.data (self:to-key k))))

  (fn VecClass.rm [self k]
    (tset self.data (self:to-key k) nil))

  (fn VecClass.ientries [self]
    (->> (_.tvals self.data)
         (_.imap (fn [{: k : v}] [k v]))))

  (fn VecClass.imvals [self]
    (->> (self:ientries)
         (_.imap (fn [[_ v]] (Maybe v))))))

;; module return

(fn [...] (VecClass:new ...))
