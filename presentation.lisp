(in-package #:slides)

(make-instance 'interface::object-view :object-class 'slide :special-view t
	       :country-languages '(:en :fr) :name "slide-over" :source-code
  `(((:div :class "panel panel-primary")
     ((:div :class "panel-heading")
      ((:h3 :class "panel-title ")
       ((:a :href (interface::encode-object-url *object*))((:slot-span title)))))
     ((:div :class "panel-body")
      (:h1 ((:slot-span title)))
      (:p ((:slot-span content)))))))

(make-instance 'interface::object-view :object-class 'presentation :special-view t
	       :country-languages '(:en :fr) :name "overview" :source-code
  `(((:div :class "panel panel-primary")
     ((:div :class "panel-heading")
      ((:h3 :class "panel-title ")
       ((:a :href (interface::encode-object-url *object*))"Overview of: "((:slot-span title)))))
     ((:div :class "panel-body")
      ((:div :style "transform:scale(0.5);transform-origin:50% 0%;")
       (loop for slide in (slides *object*) do
            (html:html (:object-view :object slide :name "slide-over"))))))))

(make-instance 'interface::object-view :object-class 'presentation :special-view nil
	       :country-languages '(:en :fr) :name "std-pres" :source-code
  `((:h1 "Presentation")
    (:slot-table title slides)
    ((:a :href (interface::encode-object-url *object* :args '(:view "overview")))
                "overview")))
