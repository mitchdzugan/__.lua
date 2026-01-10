(fn assign [dst ...]
  (let [sources [...]]
    (each [_ source (ipairs sources)]
      (each [k v (pairs source)]
        (set (. dst k) v))))
  dst)

(fn nil? [a] (= a nil))
(fn any? [a] (not= a nil))
(fn table? [a] (= (type a) "table"))
(fn num? [a] (= (type a) "number"))
(fn str? [a] (= (type a) "string"))
(fn bool? [a] (= (type a) "boolean"))
(fn fn? [a] (= (type a) "function"))
(fn co? [a] (= (type a) "thread"))

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

(fn gtr [a] (if (fn? a) a #(. $1 a)))

(fn tail [inits body-fn]
  (fn call-self [...] (tail (table.pack ...) body-fn))
  (body-fn call-self (table.unpack inits)))

(fn It [it-params]
  (local i {: it-params})
  (fn i.unpack [] (table.unpack (. i :it-params)))
  i)

(fn ifn1 [tot f]
  (fn [...]
    (let [args [...]]
      (case (- (length args) tot)
        0 (let [[ip1 & rest] args]
            (f (It [ip1]) (table.unpack rest)))
        1 (let [[ip1 ip2 & rest] args]
            (f (It [ip1 ip2]) (table.unpack rest)))
        _ (let [[ip1 ip2 ip3 & rest] args]
            (f (It [ip1 ip2 ip3]) (table.unpack rest)))))))

(local ilist (ifn1 1 #(icollect [v ($1:unpack)] v)))
(local ival-list (ifn1 1 #(icollect [_ v ($1:unpack)] v)))
(local itable (ifn1 1 #(collect [k v ($1:unpack)] (values k v))))
(fn imap-impl [map i]
  (let [f (co-wrap (fn []
                     (tail (table.pack (i:unpack))
                           (fn [recur it-fn st-t c-var]
                             (let [(k v) (it-fn st-t c-var)]
                               (if (nil? k) nil
                                   (do
                                     (coroutine.yield (table.pack (map k v)))
                                     (recur it-fn st-t k))))))))]
    #(let [{:val v : final?} (f)]
       (if final? nil (table.unpack v)))))

(fn imap [map ...]
  (imap-impl map (It [...])))

(fn imap-vals [map ...]
  (imap-impl (fn [k v] (values k (map k v))) (It [...])))

(fn mk-multi-n [n] (fn [...] (let [args [...]] (. args n))))
(local multi-1 (mk-multi-n 1))
(local multi-2 (mk-multi-n 2))
(fn ivals [...] (imap-impl multi-2 (It [...])))
(fn tvals [t] (ivals (pairs t)))

(fn inc [i] (+ i 1))
(fn dec [i] (- i 1))

(-> {: assign
     : dig
     : nil?
     : any?
     : table?
     : fn?
     : co?
     : num?
     : str?
     : bool?
     : gtr
     : ilist
     : ival-list
     : itable
     : imap
     : imap-vals
     : ivals
     : tvals
     : inc
     : dec
     : tail
     : multi-1
     : multi-2
     : co-wrap
     :co-new coroutine.create
     :co-yield coroutine.yield
     :co-check coroutine.status
     :co-play coroutine.resume})
