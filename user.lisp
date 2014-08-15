(in-package #:slides)

(defmethod interface::clipboard ((obj slides-user))
  (clipboard obj))

(defmethod meta::short-description ((user slides-user))
  (user-name user))

(defun get-user (obj)
  (when *app*
    (users *app*)))

(defmethod interface::groups ((user slides-user))
  (let ((groups nil))
    (when (or (developer user)(admin user))
      (setf groups '(:admin :owner)))
    (when (developer user) (push :dev groups))
    groups))

(defmethod interface::dynamic-groups ((user slides-user) (object slides-user) user-groups)
  (if (eq user object)
      (list* :owner user-groups)
      user-groups))

(defun start-new-slides (user)
  (unless (new-pres user)
    (let ((pres (make-instance 'presentation :parent user)))
      (setf (new-pres user) pres)))
  (interface::send-url-to-interface (interface::encode-object-url (new-dinner user))))

(make-instance 'interface::object-view :object-class 'slides-user :special-view t
	       :country-languages '(:en :fr) :name "dashboard" :source-code
  `(:br "nothing yet"
    #+nil(if (presentations *object*)
        (html:html
         (:h1 "My presentations")))
    #+nil((:fn-link start-new-pres :class "btn btn-lg btn-success") "Make a new presentation")))

(make-instance 'interface::object-view :object-class 'slides-user :special-view t
	       :country-languages '(:en :fr) :name "usettings" :source-code
  `((:h1 "My Settings")
    (:slot-table auto-login)))
