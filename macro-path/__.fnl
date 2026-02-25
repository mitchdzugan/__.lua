(local mod {})

(fn mod.defenum [name & vardefs]
  `(local ,name (let [,name ((. (require :__) :Enum) ,(tostring name))]
                  ,(icollect [_ vardef (ipairs vardefs)]
                     (let [[varname & varrest] vardef
                           [varrest1 & varrests] varrest
                           has-id? (= 1 (% (length varrest) 2))
                           id (if has-id? varrest1 nil)
                           dbody (if has-id? varrests varrest)]
                       `(: ,name "defvar" ,(tostring varname) ,id
                           ((. (require :__) :table-of-flat-kvs) ,(unpack dbody)))))
                  ,name)))

(fn mod.tail$ [params & body]
  (let [[fn-args & inits] params]
    `((. (require :__) :tail) ,inits
                              (fn [recur# ,(unpack fn-args)]
                                (#(do
                                    ,(unpack body)) recur#)))))

(local live-key (unpack (gensym)))

(fn conj [l v]
  (tset l #l v)
  l)

(fn flatten [l2d]
  (accumulate [res [] _ l1d (ipairs l2d)]
    (icollect [_ v (ipairs l1d) &into res]
      v)))

(fn flatmap [map-fn fs]
  (flatten (icollect [_ f (ipairs fs)] (map-fn f))))

(fn map-form [MOD f]
  (if (list? f)
      (let [[e1 & es] f]
        (if (= (tostring e1) :fn)
            (let [[e2 & erest] es
                  pub? (= :pub. (string.sub (tostring e2) 1 4))
                  ident (sym (string.sub (tostring e2) 5))]
              (if pub?
                  [`(var ,ident nil)
                   `(set ,ident (let [f# (fn ,(unpack erest))]
                                  (set (. ,MOD :pub :exports ,(tostring ident))
                                       f#)
                                  f#))]
                  [f]))
            (= (tostring e1) :import)
            (let [[ident reqstring_] es
                  reqstring (or reqstring_ (tostring ident))]
              [`(var ,ident nil)
               `(set ,ident
                     ((. (require :__) :import) ,reqstring #(set ,ident $1)))])
            (= (tostring e1) :exp)
            (let [[value] es]
              [`(let [v# ,value]
                  (set (. ,MOD :pub :exports) v#)
                  v#)])
            (= (tostring e1) :pub-)
            (let [[ident value] es]
              [`(let [v# ,value]
                  (set (. ,MOD :pub :exports ,(tostring ident)) v#)
                  v#)])
            (= (tostring e1) :pub)
            (let [[ident value] es]
              [`(local ,ident (let [v# ,value]
                                (set (. ,MOD :pub :exports ,(tostring ident))
                                     v#)
                                v#))])
            [f]))
      [f]))

(fn swap-sym [_Sym f]
  (if (and (multi-sym? f)
        (= f (sym (tostring f))))
      (let [[s1 & ss] (multi-sym? f)]
        (if (= "_" (tostring s1))
            (sym (accumulate [res (tostring _Sym) _ s (ipairs ss)]
                   (.. res "." (tostring s))))
            f))
      (and (sym? f)
        (= f (sym (tostring f))))
      (if (= "_" (tostring f)) f
          (= "loc" (tostring f))
          (sym :local)
          f)
      (sequence? f)
      (do
        (var seen-amp? false)
        (var prev-amp? false)
        (each [_ ff (ipairs f)]
          (set prev-amp? (and (not prev-amp?) seen-amp?))
          (set seen-amp? (or seen-amp? (= ff (sym "&")))))
        (if prev-amp?
            f
            (icollect [_ ff (ipairs f)] (swap-sym _Sym ff))))
      (list? f)
      (let [[f1 & fs] f]
        (if (= f1 (sym "icollect"))
            (let [[binds & fbody] fs
                  [sk sv fl] binds]
              `(icollect [,sk ,sv ,(swap-sym _Sym fl)]
                 ,(unpack (icollect [_ ff (ipairs fbody)] (swap-sym _Sym ff)))))
            (= f1 (sym "icollect_"))
            (let [[binds & fbody] fs
                  [sv fl] binds]
              `(icollect [_ignore# ,sv ,(swap-sym _Sym fl)]
                 ,(unpack (icollect [_ ff (ipairs fbody)] (swap-sym _Sym ff)))))
            (= f1 (sym "collect"))
            (let [[binds & fbody] fs
                  [sk sv fl] binds]
              `(collect [,sk ,sv ,(swap-sym _Sym fl)]
                 ,(unpack (icollect [_ ff (ipairs fbody)] (swap-sym _Sym ff)))))
            (= f1 (sym "collect_"))
            (let [[binds & fbody] fs
                  [sv fl] binds]
              `(collect [_ignore# ,sv ,(swap-sym _Sym fl)]
                 ,(unpack (icollect [_ ff (ipairs fbody)] (swap-sym _Sym ff)))))
            (= f1 (sym "accumulate"))
            (let [[binds & fbody] fs
                  [sa fi sk sv fl] binds]
              `(accumulate [,sa ,(swap-sym _Sym fi) ,sk ,sv ,(swap-sym _Sym fl)]
                 ,(unpack (icollect [_ ff (ipairs fbody)] (swap-sym _Sym ff)))))
            (= f1 (sym "accumulate_"))
            (let [[binds & fbody] fs
                  [sa fi sv fl] binds]
              `(accumulate [,sa ,(swap-sym _Sym fi) _ignore# ,sv ,(swap-sym _Sym
                                                                            fl)]
                 ,(unpack (icollect [_ ff (ipairs fbody)] (swap-sym _Sym ff)))))
            (= f1 (sym "fcollect"))
            (let [[binds & fbody] fs
                  [si fl fu] binds]
              `(fcollect [,si ,(swap-sym _Sym fl) ,(swap-sym _Sym fu)]
                 ,(unpack (icollect [_ ff (ipairs fbody)] (swap-sym _Sym ff)))))
            (= f1 (sym "faccumulate"))
            (let [[binds & fbody] fs
                  [sa fi si fl fu] binds]
              `(faccumulate [,sa ,(swap-sym _Sym fi) ,si ,(swap-sym _Sym fl) ,(swap-sym _Sym
                                                                                        fu)]
                 ,(unpack (icollect [_ ff (ipairs fbody)] (swap-sym _Sym ff)))))
            (case (multi-sym? f1)
              (where [s1 s2 nil]
                     (and (= f1 (sym (tostring f1)))
                       (= "_" (tostring s1))
                       (not= nil (. mod (tostring s2)))))
              ((. mod (tostring s2)) (unpack (icollect [_ ff (ipairs fs)]
                                               (swap-sym _Sym ff))))
              _ (list (unpack (icollect [_ ff (ipairs f)] (swap-sym _Sym ff)))))))
      (table? f)
      (collect [fk fv (pairs f)]
        (values (swap-sym _Sym fk) (swap-sym _Sym fv)))
      f))

(fn mod.module [& body]
  (let [_Sym (gensym)
        MOD (gensym)]
    `(let [,_Sym (require :__)
           ,MOD {:pub {:exports {}
                       :$$:module {:key (or ((. (require :__) :get-key))
                                            (fn []))
                                   :id (or "." "")}}
                 :imports {}}]
       ((fn []
          ,(unpack (->> (icollect [_ f (ipairs body)] (swap-sym _Sym f))
                        (flatmap #(map-form MOD $1))))))
       (. ,MOD :pub))))

(fn filter-forms [preG? forms]
  (var seenG? false)
  (icollect [_ form (ipairs forms)]
    (let [G? (and (sym? form) (= "&" (tostring form)))]
      (set seenG? (or seenG? G?))
      (when (and (not G?)
              (or (and preG? (not seenG?)) (and seenG? (not preG?))))
        form))))

(fn starts-with? [s start]
  (= start (s:sub 1 (length start))))

(fn filter-forms% [preG? forms]
  (var seenG? false)
  (icollect [_ form (ipairs forms)]
    (let [G? (and (sym? form) (starts-with? (tostring form) "&"))]
      (set seenG? (or seenG? G?))
      (if (and G? (not preG?))
          (: (tostring form) :sub 2)
          (and (not G?)
            (or (and preG? (not seenG?)) (and seenG? (not preG?))))
          form
          nil))))

(fn mod.|| [& body]
  (let [preG (filter-forms true body)
        postG (filter-forms false body)]
    `((. ,(unpack preG)) ,(unpack postG))))

(fn mod.|% [& body]
  (let [preG (filter-forms% true body)
        postG (filter-forms% false body)]
    `(: (. ,(unpack preG)) ,(unpack postG))))

mod
