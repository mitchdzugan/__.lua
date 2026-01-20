(local M {:active-set {}})

(fn M.get-key [] (. M :active-key))

(macro with-key [M & body]
  `(do
     (set (. ,M :active-key) (or ((. ,M :get-key)) (fn [])))
     (let [res# (do
                  ,(unpack body))]
       (set (. ,M :active-key) nil)
       res#)))

(fn M.meta [m ...]
  (?. m :$$:module ...))

(fn M.new-key []
  (set M.active-key (fn [])))

(local fennel (require :fennel))
(local {: dbg} (require :dbg))

(fn M.made-now? [m]
  (let [key (M.meta m :key)]
    (and key (= :Fennel (?. (fennel.getinfo key) :what)))))

(fn M.import [reqstring set-val]
  (with-key M
    (let [mod (require reqstring)]
      (when (M.made-now? mod)
        (tset M.active-set reqstring set-val))
      mod)))

(fn M.reload-modules! []
  (let [reloads (icollect [reqstring set-val (pairs M.active-set)]
                  (do
                    (tset package.loaded reqstring nil)
                    #(set-val (M.import reqstring set-val))))]
    (set M.active-set {})
    (each [_ reload (ipairs reloads)] (reload))))

M
