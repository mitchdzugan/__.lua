(local _ (require :core))

(local Str {})
(local MetaStr {})

(fn Str.sub [s ...] (s:sub ...))
(fn Str.gsub [s ...] (s:gsub ...))
(fn Str.fmt [...] (string.format ...))
(fn Str.match [...] (string.match ...))
(fn Str.gmatch [...] (string.gmatch ...))

(fn Str.starts-with? [s start]
  (= start (s:sub 1 (length start))))

(fn Str.ends-with? [s end]
  (= end (s:sub (_.inc (- (length s) (length end))))))

(fn Str.trim-l [s] (s:gsub "^%s+" ""))
(fn Str.trim-r [s] (s:gsub "%s+$" ""))
(fn Str.trim [s] (-> s Str.trim-l Str.trim-r))

(fn Str.split [s sep]
  (icollect [p (Str.gmatch s (.. "([^" (or sep "%s") "]+)"))]
    p))

(fn MetaStr.__call [_ ...]
  (accumulate [res "" _ s (ipairs [...])]
    (.. res (tostring s))))

(setmetatable Str MetaStr)
