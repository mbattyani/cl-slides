; -*- mode:common-lisp -*-

(in-package #:asdf)

(defsystem :cl-slides
  :name "cl-slides"
  :description "cl-slides is a presentation application written with the cl-fff framework to write a presentation about cl-fff for the ILC2014."
:serial t
:components ((:file "package")
               (:file "specials")
	     ;  (:file "mixins-classes" :depends-on ("specials"))
	       (:file "slides-classes")
	       (:file "pages")
	       (:file "style")
               (:file "user")
               (:file "slides-app")
               (:file "global"))
  :depends-on (:webapp :iterate :optima :fare-quasiquote-extras))
