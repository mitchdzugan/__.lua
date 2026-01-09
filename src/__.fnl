(local inspect (require :inspect))

(fn assign [dst ...]
  (let [sources [...]]
    (each [_ source (ipairs sources)]
      (each [k v (pairs source)]
        (set (. dst k) v))))
  dst)

(fn table? [a] (= (type a) "table"))
(fn fn? [a] (= (type a) "function"))
(fn co? [a] (= (type a) "thread"))

(fn dbg [v] (print (inspect v)))

(fn dig [t ks fallback]
  (if (or (not (table? t)) (= 0 (length ks)))
      (or t fallback)
      (let [[ks1 & ks-rest] ks]
        (dig (. t ks1) ks-rest fallback))))

(fn co-wrap [f]
  (var final? false)
  (fn outer-wrapped [...]
    (let [res (f ...)]
      (set final? true)
      res))
  (let [inner-wrapped (coroutine.wrap outer-wrapped)]
    #{:val (inner-wrapped $...) : final?}))

{: assign
 : dig
 : table?
 : fn?
 : co?
 : dbg
 : co-wrap
 :co-new coroutine.create
 :co-yield coroutine.yield
 :co-check coroutine.status
 :co-play coroutine.resume}
