(local M {:active-set {} :full-set {}})

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
(local _ (require :core))

(fn M.module? [m]
  (let [key (M.meta m :key)]
    (_.fn? key)))

(fn M.made-now? [m]
  (let [key (M.meta m :key)]
    (and key (= :Fennel (?. (fennel.getinfo key) :what)))))

(fn M.import [reqstring set-val]
  (with-key M
    (let [mod (require reqstring)]
      (when (M.module? mod)
        (tset M.full-set reqstring set-val))
      (when (M.made-now? mod)
        (tset M.active-set reqstring set-val))
      mod)))

(fn M.refresh-modules! []
  (let [reloads (icollect [reqstring set-val (pairs M.active-set)]
                  (do
                    (tset package.loaded reqstring nil)
                    #(set-val (M.import reqstring set-val))))]
    (set M.active-set {})
    (each [_ reload (ipairs reloads)] (reload))))

(fn M.reload-modules! []
  (let [reloads (icollect [reqstring set-val (pairs M.full-set)]
                  (do
                    (tset package.loaded reqstring nil)
                    #(set-val (M.import reqstring set-val))))]
    (set M.full-set {})
    (each [_ reload (ipairs reloads)] (reload))))

M
