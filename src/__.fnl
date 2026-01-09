(fn assign [dst ...]
  (let [sources [...]]
    (each [_ source (ipairs sources)]
      (each [k v (pairs source)]
        (set (. dst k) v))))
  dst)

(fn table? [a] (= (type a) "table"))
(fn fn? [a] (= (type a) "function"))
(fn co? [a] (= (type a) "thread"))

(local inspect (require :inspect))
(fn debug [v] (print (inspect v)))
(fn dig [t ...]
  (let [args [...]]
    (if (or (not (table? t)) (= 0 (length args)))
        t
        (let [[k & rest] args]
          (dig (. t k) (unpack rest))))))

{: assign
 : dig
 : table?
 : fn?
 : co?}
