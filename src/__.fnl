(local _ (require :core))
(local class (require :class))
(local dbg (require :dbg))
(local Maybe (require :Maybe))
(local Map (require :Map))
(local Enum (require :Enum))
(local module_ (require :module))

(_.assign {: Maybe : Map : Enum} dbg class module_ _)
