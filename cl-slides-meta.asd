; -*- mode:common-lisp -*-

(in-package #:asdf)

(defsystem :cl-slides-meta
  :name "cl-slides-meta"
  :description "The meta-web interface for cl-slides"
  :components ((:file "slides-meta"))
  :depends-on (:meta-web))
