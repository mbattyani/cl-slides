
(defpackage slides
  (:use common-lisp webapp #:iterate #:fare-quasiquote #:editor-hints.named-readtables #:optima)
  (:shadowing-import-from meta-level defclass)
  (:import-from interface *user* *session* *object* *request* *country-language* *user-groups*)
  )
