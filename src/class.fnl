(local _ (require :core))
(local _class (require :middleclass))

(local BASE_CLASS_IDENT (fn []))

(local BaseClass (_class "BaseClase"))
(fn BaseClass.get-base-class-ident [] BASE_CLASS_IDENT)

(fn subclass? [any base]
  (and (_.table? any) (_.fn? any.get-base-class-ident)
       (= (any.get-base-class-ident) BASE_CLASS_IDENT)
       (any:isInstanceOf (or base BaseClass))))

(fn class [name ...]
  (_class name BaseClass ...))

{: class : subclass?}
