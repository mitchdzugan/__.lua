(import-macros {: desc : spec} :busted)
(import-macros _ :__-macros)

(_.defenum Dir
  (North :vert? true)
  (South :vert? true)
  (East)
  (West))

(desc "Enum"
  (spec "works"
    (assert.same Dir.South (Dir Dir.South.id))))
