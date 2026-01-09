(fn context [s & body] `(describe ,s (fn [] (do ,(unpack body)) nil)))
(fn specify [s & body] `(it ,s (fn [] (do ,(unpack body)) nil)))

{: context
 : specify}
