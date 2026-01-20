(import-macros _ :__)
(print :requiring :outermost)

(_.module
 (import __)
 (fn pub.inc [x] (__.inc x)))
