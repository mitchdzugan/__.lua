(fn get [& args] `((. (require :ctx) :get) ,(unpack args)))
(fn put [& args] `((. (require :ctx) :put) ,(unpack args)))
(fn with [m & body]
      `(let [ctx# (require :ctx)]
         (ctx#.with ,m (fn [] ,(unpack body)))))
(fn exec [c & body]
      `(let [ctx# (require :ctx)]
         (ctx#.exec ,c (fn [] ,(unpack body)))))

{: exec
 : put
 : get
 : with}
