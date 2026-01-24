(local im-sym-strs ["clone"
                    "deep-clone"
                    "assoc"
                    "assoc-in"
                    "push"
                    "concat"
                    "update"
                    "update-in"
                    "list"
                    "list?"
                    "merge"
                    "merge-with"
                    "merge-all"
                    "get"
                    "get-in"])

(local im-mod {})

(each [_ sym-str (pairs im-sym-strs)]
  (tset im-mod sym-str
        (fn [& body]
          `((. (require :__) :im ,sym-str) ,(unpack body)))))

(local sym-strs ["dig"
                 "starts-with?"
                 "ilist"
                 "dbg-str"
                 "tvals"
                 "dec"
                 "multi-1"
                 "co?"
                 "nil?"
                 "gtr"
                 "any?"
                 "str?"
                 "co-new"
                 "inc"
                 "ivals"
                 "itable"
                 "fn?"
                 "assign"
                 "co-check"
                 "ival-list"
                 "subclass?"
                 "Maybe"
                 "table?"
                 "co-play"
                 "dbg"
                 "co-yield"
                 "imap"
                 "unpack"
                 "pack"
                 "bool?"
                 "co-wrap"
                 "class"
                 "multi-2"
                 "imap-vals"
                 "num?"
                 "reload-modules!"
                 "refresh-modules!"
                 "Map"
                 "tail"])

(local mod {})

(set mod.im im-mod)

(each [_ sym-str (pairs sym-strs)]
  (tset mod sym-str
        (fn [& body]
          `((. (require :__) ,sym-str) ,(unpack body)))))

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

(fn mod.R [binding _reqstring]
  (let [reqstring (or _reqstring (tostring binding))]
    `(local ,binding (require ,reqstring))))

(fn mod.R$ [binding _reqstring]
  (let [reqstring (or _reqstring (tostring binding))]
    `(do
       (tset $1 ,(tostring binding)
             (do
               (when (not (. $1.required ,reqstring))
                 (tset package.loaded ,reqstring nil))
               (tset $1.required ,reqstring ,(tostring binding))
               (require ,reqstring)))
       (. $1 ,(tostring binding)))))

(fn mod.REREQUIRE$ []
  `(each [reqstring# binding# (pairs $1.required)]
     (tset package.loaded reqstring# nil)
     (tset $1 binding# (require reqstring#))))

(fn mod.L [& body]
  `(local ,(unpack body)))

(fn mod.tail$ [params & body]
  (let [[fn-args & inits] params]
    `((. (require :__) :tail) ,inits
                              (fn [recur# ,(unpack fn-args)]
                                (#(do
                                    ,(unpack body)) recur#)))))

(local live-key (unpack (gensym)))

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
            (= (tostring e1) :loc)
            [`(local ,(unpack es))]
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

(fn conj [l v]
  (tset l #l v)
  l)

(fn flatten [l2d]
  (accumulate [res [] _ l1d (ipairs l2d)]
    (icollect [_ v (ipairs l1d) &into res]
      v)))

(fn mod.module [& body]
  (let [MOD (gensym)]
    `(let [,MOD {:pub {:exports {}
                       :$$:module {:key (or ((. (require :__) :get-key))
                                            (fn []))
                                   :id (or "." "")}}
                 :imports {}}]
       ((fn []
          ,(unpack (flatten (icollect [_ f (ipairs body)]
                              (map-form MOD f))))))
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
      (if (and G? (not preG?)) (: (tostring form) :sub 2)
          (and (not G?) (or (and preG? (not seenG?)) (and seenG? (not preG?)))) form
          nil))))

(fn mod.|| [& body]
  (let [preG (filter-forms true body)
        postG (filter-forms false body)]
    `((. ,(unpack preG)) ,(unpack postG))))

(fn mod.|% [& body]
  (let [preG (filter-forms% true body)
        postG (filter-forms% false body)]
    `(: (. ,(unpack preG)) ,(unpack postG))))

(fn mod.M$ [& body]
  `(#(do
       ,body
       $1.exports) {:exports {} :required {}}))

mod
