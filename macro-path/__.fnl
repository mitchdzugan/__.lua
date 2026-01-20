(local sym-strs ["dig"
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
                  [`(local ,ident (let [f# (fn ,(unpack erest))]
                                    (set (. ,MOD :pub ,(tostring ident)) f#)
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
            (= (tostring e1) :pub)
            (let [[ident value] es]
              [`(local ,ident (let [v# ,value]
                                (set (. ,MOD :pub ,(tostring ident)) v#)
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
    `(let [,MOD {:pub {:$$:module {:key ((. (require :__) :get-key))
                                   :id (or "." "")}}
                 :imports {}}]
       ((fn []
          ,(unpack (flatten (icollect [_ f (ipairs body)]
                              (map-form MOD f))))))
       (. ,MOD :pub))))

(fn mod.M$ [& body]
  `(#(do
       ,body
       $1.exports) {:exports {} :required {}}))

mod
