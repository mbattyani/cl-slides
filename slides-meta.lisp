
;;; to create the empty meta store
(defun create-cl-slides-meta ()
  (setf mw::*local-port* 25144)
  (meta-web::start :ascii-store-path (asdf:system-relative-pathname :cl-slides "./meta-store/") :first-start t))

(defun start-cl-slides-meta ()
  (setf mw::*local-port* 25144)
  (meta-web::start :ascii-store-path (asdf:system-relative-pathname :cl-slides "./meta-store/")))
