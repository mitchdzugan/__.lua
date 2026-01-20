(import-macros _ :__)
(print :requiring :outermost)
(_.module (print :requiring :in-module) (import __) (fn pub.inc [x] (__.inc x)))
