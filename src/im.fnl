(local _ (require :core))

(local im {})

(local ListMetatable {})

(fn im.list [...]
  (let [l [...]]
    (setmetatable l ListMetatable)))

(fn im.list? [a] (= ListMetatable (getmetatable a)))

(fn im.clone [a deep?]
  (fn clone-table [t]
    (let [res {}]
      (each [k v (pairs t)]
        (tset res k (if deep? (im.clone v deep?) v)))
      res))

  (if (_.table? a) (setmetatable (clone-table a) (getmetatable a)) a))

(fn im.deep-clone [a] (im.clone a true))
(fn im.push [t v]
  (im.assoc t (_.inc (length t)) v))

(fn concat2 [t l]
  (accumulate [res t _ v (ipairs l)]
    (im.push res v)))

(fn im.concat [t ...]
  (let [ls [...]]
    (accumulate [res t _ l (ipairs ls)]
      (concat2 res l))))

(fn im.assoc [t k v]
  (setmetatable (_.assign {} (or t {}) {k v}) (getmetatable t)))

(fn im.assoc-in [t ks v]
  (case ks
    [k & ksnext] (im.assoc t k (im.assoc-in (?. t k) ksnext v))
    [] v))

(fn im.update [t k f]
  (im.assoc t k (f (?. t k))))

(fn with-fb [v fb] (if (_.nil? v) fb v))

(fn im.get [t k fb] (with-fb (?. t k) fb))

(fn im.get-in [t ks fb]
  (case [ks t]
    [[] nil] fb
    [[k & ksnext]] (im.get-in (im.get t k) ksnext fb)
    [] t))

(fn im.update-in [t ks f]
  (im.assoc-in t ks (f (im.get-in t ks))))

(fn im.merge [...]
  (_.assign {} ...))

im
