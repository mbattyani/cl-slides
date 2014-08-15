(in-package #:slides)

(defmethod interface::localize ((obj slides-app))
  ())

(make-instance 'interface::object-view :object-class 'slides-app ; :special-view t
	       :country-languages '(:en :fr) :name "admin" :source-code
  `((:h1 "Administration")
    (:tab
     ("App Dashboard"
      (:h4 "Statistics")
      (:p (:format "~d users, ~d currently connected"
                    (length (users *app*))(hash-table-count interface::*sessions*)))
     ("Users"
      (:slot-table users))))))
