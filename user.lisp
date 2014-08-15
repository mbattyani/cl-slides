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

(defmethod interface::dynamic-groups ((user slides-user) (object presentation) user-groups)
  (if (eq user (meta::parent object))
      (list* :author user-groups)
      user-groups))

(defmethod interface::dynamic-groups ((user slides-user) (object slide) user-groups)
  (interface::dynamic-groups user (meta::parent object) user-groups))

(defun start-new-pres (user)
  (let ((pres (make-instance 'presentation :parent user)))
    (push pres (presentations user))
    (interface::send-url-to-interface (interface::encode-object-url pres))))

(make-instance 'interface::object-view :object-class 'slides-user :special-view t
	       :country-languages '(:en :fr) :name "dashboard" :source-code
  `(:br
    (:h1 "My presentations")
    (:slot-table presentations)
    ((:fn-link start-new-pres :class "btn btn-lg btn-success") "Make a new presentation")))

(make-instance 'interface::object-view :object-class 'slides-user :special-view t
	       :country-languages '(:en :fr) :name "usettings" :source-code
  `((:h1 "My Settings")
    (:slot-table user-name auto-login)))
