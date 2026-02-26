(fn for-each [a f]
  (local used-inds {})
  (each [ind v (ipairs a)]
    (tset used-inds ind true)
    (f v ind a f))
  (each [k v (pairs a)]
    (when (not (. used-inds k))
      (f v k a f))))

(fn reduce [a f i]
  (var acc i)
  (for-each a #(set acc (f acc $1 $2 $3 $4 i)))
  acc)

(fn mapv [a f]
  (icollect [ind v (ipairs a)]
    (f v ind a f)))

(local filter #(mapv $1 (fn [v ...] (when ($2 v ...) v))))

(-> {: for-each : mapv : filter : reduce})
