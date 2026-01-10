(local sym-strs
       ["dig"
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
        "bool?"
        "co-wrap"
        "class"
        "multi-2"
        "imap-vals"
        "num?"
        "Map"
        "tail"])

(local mod {})

(each [_ sym-str (pairs sym-strs)]
  (tset mod
        sym-str
        (fn [& body]
          `((. (require :__) ,sym-str) ,(unpack body)))))

(fn mod.defenum [name & vardefs]
  `(local ,name
          (let [,name ((. (require :__) :Enum) ,(tostring name))]
            ,(icollect [_ vardef (ipairs vardefs) ]
                      (let [[varname & varrest] vardef
                            [varrest1 & varrests] varrest
                            has-id? (= 1 (% (length varrest) 2))
                            id (if has-id? varrest1 nil)
                            dbody (if has-id? varrests varrest)]
                        `(: ,name
                            "defvar"
                            ,(tostring varname)
                            ,id
                            ((. (require :__) :table-of-flat-kvs)
                             ,(unpack dbody)))))
            ,name)))

; (print (macroexpand `(mod.defenum Dir (N) (S) (E) (W))))

mod
