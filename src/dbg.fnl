(local inspect (require :inspect))
(local class (require :class))

(fn dbg-str [item opts]
  (local skip-keys {:class true})

  (fn process [obj]
    (if (class.subclass? obj)
        (collect [k v (pairs obj) &into {:__CLASS obj.class.name}]
          (if (not (. skip-keys k))
              (values k v)))
        obj))

  (inspect item {:process process}))

(fn dbg [item opts] (print (dbg-str item opts)) item)

{: dbg : dbg-str}
