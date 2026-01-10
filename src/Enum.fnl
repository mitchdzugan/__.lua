(local _ (require :core))
(local c (require :class))

;; module impl

(local EnumClass (c.class :EnumClass))

(fn EnumClass.initialize [self enum-name]
  (set self.enum-name enum-name)
  (set self.next-id 1)
  (set self.var-by-name {})
  (set self.name-by-id {}))

(fn EnumClass.defvar [self name ...]
  (let [[a1 a2] [...]
        (_id data) (if (_.table? a1) (values nil a1) (values a1 a2))
        id (or _id self.next-id)
        v (_.assign {} data {: name : id })]
    (when (and (_.num? id)
               (>= id self.next-id))
      (set self.next-id (_.inc id)))
    (_.assign self.var-by-name {name v})
    (_.assign self.name-by-id {id name})))

(fn EnumClass.__index [self name]
  (. self :var-by-name name))

(fn EnumClass.__call [self id]
  (. self :var-by-name (. self :name-by-id id)))

;; module return

(fn [enum-name] (EnumClass:new enum-name))
