(in-package #:slides)

(make-instance 'interface::object-view :object-class 'slide :special-view t
	       :country-languages '(:en :fr) :name "slide-show-only" :source-code
  `(((:div :fformat (:id "~s" (meta::id *object*)) :class "slide")
     ((:div :class "panel panel-primary")
      ((:div :class "panel-heading")
       ((:h3 :class "panel-title ")
        ((:a :href (obj-url *object* "slide-show" "raw-page"))((:slot-span title)))))
      ((:div :class "panel-body")
       (:p ((:slot-span content))))))))

(make-instance 'interface::object-view :object-class 'presentation :special-view t
	       :country-languages '(:en :fr) :name "overview" :source-code
  `(((:div :class "panel panel-primary")
     ((:div :class "panel-heading")
      ((:h3 :class "panel-title ")
       ((:a :href (obj-url *object*))"Overview of: "((:slot-span title)))))
     ((:div :class "panel-body")
      ((:div :style "transform:scale(0.5);transform-origin:50% 0%;")
       (loop for slide in (slides *object*) do
            (html:html (:object-view :object slide :name "slide-show-only"))))))))

(make-instance 'interface::object-view :object-class 'presentation :special-view nil
	       :country-languages '(:en :fr) :name "std-pres" :source-code
  `((:h1 "Presentation")
    (:slot-table title slides)
    (:p ((:a :href (obj-url *object* "pres-show" "raw-page"))
         ((:button :type "button" :class "btn btn-success") "Start Presentation"))
        ((:a :href (obj-url *object* "overview"))
         ((:button :type "button" :class "btn btn-primary") "overview")))))

(make-instance 'interface::object-view :object-class 'slide :special-view t
	       :country-languages '(:en :fr) :name "slide-show" :source-code
               `(((:div :id "100013" :style "width: 100%;height: 100%;")
                  (:object-view :object *object* :name "slide-show-only"))
                 (:jscript "enableToggleFullScreen();")))

(defun rnd10k ()
  (- (random 4000) 2000))

(make-instance 'interface::object-view :object-class 'presentation :special-view t
	       :country-languages '(:en :fr) :name "pres-show" :source-code
 `(((:div :class "wrap3D")
    ((:div :id "slides" :class "slides")
     (loop for slide in (slides *object*) do
          (html:html (:object-view :object slide :name "slide-show-only")))))
   (:jscript "enableNavKeys();"
    (loop for slide in (slides *object*)
           for z from -150 by -50 do
          (html:html (:fformat "fgt(~s).style.WebkitTransform = 'translate3d(~apx,~apx,~apx) rotateY(~adeg) rotateX(~adeg)';"
                               (meta::id slide)(rnd10k)(rnd10k)(rnd10k)(rnd10k)(rnd10k)))))
   (:ps (defvar slides-args
          (ps:lisp `(array ,@(loop for (slide . next) on (slides *object*)
                                for i from 0
                                for x from 0 by -100
                                for z from -2000 by -100
                                               for y from 200 by -30
                                collect `(array ,(meta::id slide)
                                                ,(format nil "translate3d(~apx,~apx,~apx) rotateY(50deg) rotateX(20deg)" x y z)
                                                ,(when next (1+ i))
                                                ,(unless (zerop i) (1- i)))))))
        (defun reset-slides ()
          (loop for i from 0 below (ps:lisp (length (slides *object*)))
                do (hide-slide i))))))
