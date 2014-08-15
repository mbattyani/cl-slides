(in-package #:slides)

(defvar *app-store* nil)
(defvar *save-database* t)
(defvar *in-store-timer* nil)
(defvar *projects-list* nil)
(defvar *app-store-timer* nil)
(defparameter *database-save-period* 30)

(defparameter *local-port* 25143)
(defparameter *hunchentoot-acceptor* nil)
(setf interface:*server-name* "127.0.0.1")

(defparameter *web-directory* (asdf:system-relative-pathname :cl-slides "./web-resources/"))

(defun start-hunchentoot ()
  (setf *hunchentoot-acceptor* (make-instance 'hunchentoot:easy-acceptor :port *local-port*  :document-root (namestring *web-directory*) :message-log-destination nil :access-log-destination nil))
  (hunchentoot:start *hunchentoot-acceptor*))

(defun stop-hunchentoot ()
  (hunchentoot:stop *hunchentoot-acceptor*))


;; mongo store is not used here
(defparameter *mongo-collection-name* "slides")

(defun clear-db ()
  (mapcar (lambda (x)
            (cl-mongo:db.delete *mongo-collection-name* x))
          (cadr (cl-mongo:db.find *mongo-collection-name* :all))))

(defun app-store-timer-fn ()
  (unless *in-store-timer*
    (setf *in-store-timer* t)
    (unwind-protect
	 (when (and *app-store* *save-database*)
	   (setf *save-database* nil)
	   (util:with-logged-errors (:ignore-errors nil) ; t
	     (meta::save-modified-objects *app-store*))
	   (setf *save-database* t))
      (setf *in-store-timer* nil))))

(defun start-app-store-timer ()
  (let ((timer (mp:make-timer 'app-store-timer-fn)))
    (mp:schedule-timer-relative timer *database-save-period* *database-save-period*)))

(defun create-store (database-type)
  (meta::initialize-store *app-store*)
  (when (eq database-type :postgres)
    (create-app-classes *app-store*)))

(defun start-apache () ;; if apache is used
  (interface:sa *mod-lisp-port*))

(defun start (&key (webserver :hunchentoot) (database :text-files) (first-start nil) (mongo-db-name "mydb")
                (mongo-db-collection-name *mongo-collection-name*) debug (init-file nil)
                ascii-store-path)
  (assert (and (member webserver '(:hunchentoot :apache))
               (member database '(:mongo-db :text-files :memory))))
  (setf interface:*web-server* webserver)
  (when debug
    (log:config debug))
  (when init-file
    (load init-file))

  ;; data stores
  (case database
    (:mongo-db
     (setf *app-store* (make-instance 'meta:mongo-store :database-name mongo-db-name :collection-name mongo-db-collection-name)))
    (:text-files
     (setf *app-store* (make-instance 'meta::ascii-store
                                       :file-directory (or ascii-store-path (asdf:system-relative-pathname :cl-slides "./db-store/")))))
    (:memory
     (setf *app-store* (make-instance 'meta::void-store))))
  (when first-start
    (create-store database))
  (unless meta::*memory-store*
    (setf meta::*memory-store* (make-instance 'meta::void-store)))
  (setf *app* (meta::load-or-create-named-object *app-store* "slides-app" 'slides-app))
  (setf *app-store-timer* (start-app-store-timer))

  ;; web server
  (case webserver
    (:hunchentoot
     (setf (symbol-function 'interface::write-request)
           #'interface::write-hunchentoot-request) ;; FIXME hack
     (setf (symbol-function 'interface::write-header)
           #'interface::write-hunchentoot-header) ;; FIXME hack
     (start-hunchentoot))
    (:apache
     (start-apache))))
