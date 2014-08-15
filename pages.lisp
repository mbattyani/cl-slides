(in-package #:slides)

(defclass home-page-desc (page-desc)
  ())

(defclass obj-page-desc (page-desc)
  ())

(make-instance 'home-page-desc
   :name "home"
   :title "Slides - Home"
   :content '())

(make-instance 'obj-page-desc
   :name "object"
   :title "CL-Slides - "
   :content '())

(make-instance 'page-desc
   :name "settings"
   :title "Settings"
   :content '(:progn
              ((:section)
               ((:div :class "page-header"))
               (:h1 "Settings")
               (:object-view *app*))))
