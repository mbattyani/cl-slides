(in-package "SLIDES")

(defun convert-base-from-version--1-to-0 (store)
  (dolist (class '(slides-app slides-user))
     (meta::create-class-table store (find-class class)))


)
