(in-package "SLIDES")

(defvar *slides-classes-list* '(slides-user slides-app slide presentation))

(defun create-slides-classes (store)
  (dolist (class *slides-classes-list*)
     (meta::create-class-table store (find-class class))))

(prog1
    (meta-level:defclass slides-user
                         nil
                         ((user-name :value-type string :user-name (make-instance 'meta-level:translated-string :en "User name") :choices (list) :visible t :modifiable-groups '(:owner) :new-objects-first nil :sql-length 0 :nb-decimals 0 :get-value-sql "" :view-type :default)
                          (password :value-type string :user-name (make-instance 'meta-level:translated-string :en "Password") :choices (list) :new-objects-first nil :sql-length 0 :nb-decimals 0 :get-value-sql "" :view-type :default)
                          (admin :value-type boolean :user-name (make-instance 'meta-level:translated-string :en "Administrator") :choices (list) :visible t :modifiable-groups '(:admin) :new-objects-first nil :sql-length 0 :nb-decimals 0 :get-value-sql "" :view-type :default)
                          (developer :value-type boolean :user-name (make-instance 'meta-level:translated-string :en "Developer") :choices (list) :visible t :modifiable-groups '(:admin) :new-objects-first nil :sql-length 0 :nb-decimals 0 :get-value-sql "" :view-type :default)
                          (cookie :value-type string :user-name (make-instance 'meta-level:translated-string :en "Cookie") :choices (list) :new-objects-first nil :sql-length 0 :nb-decimals 0 :get-value-sql "" :view-type :default)
                          (auto-login :value-type boolean :user-name (make-instance 'meta-level:translated-string :en "Auto-login") :choices (list) :visible t :modifiable-groups '(:admin) :new-objects-first nil :sql-length 0 :nb-decimals 0 :get-value-sql "" :view-type :default)
                          (clipboard :value-type string :user-name (make-instance 'meta-level:translated-string :en "clipboard") :initform (make-instance 'interface::clipboard :store meta-level::*memory-store*) :choices (list) :stored nil :new-objects-first nil :sql-length 0 :nb-decimals 0 :get-value-sql "" :view-type :default)
                          (presentations :value-type presentation :user-name (make-instance 'meta-level:translated-string :en "Presentations") :choices (list) :visible t :modifiable-groups '(:author) :list-of-values t :new-objects-first nil :sql-length 0 :nb-decimals 0 :can-create-new-object t :get-value-sql "" :view-type :list-val))
                         (:user-name (make-instance 'meta-level:translated-string :en "User") :guid 1 :functions (list (make-instance 'meta-level::fc-function :name 'start-new-pres :user-name (make-instance 'meta-level:translated-string :en "Start a new presentation") :visible t :visible-groups '(:owner) :get-value-sql "")))))

(prog1 (meta-level:defclass slides-app nil ((users :value-type slides-user :user-name (make-instance 'meta-level:translated-string :en "CL-Slides users") :choices (list) :visible t :modifiable-groups '(:dev) :list-of-values t :sql-length 0 :nb-decimals 0 :get-value-sql "" :view-type :list-val)) (:user-name (make-instance 'meta-level:translated-string :en "The CL-Slides App") :guid 2)))

(prog1 (meta-level:defclass slide nil ((title :value-type string :user-name (make-instance 'meta-level:translated-string :en "Title") :choices (list) :visible t :modifiable-groups '(:author) :new-objects-first nil :sql-length 0 :nb-decimals 0 :get-value-sql "" :view-type :default) (content :value-type string :user-name (make-instance 'meta-level:translated-string :en "Content") :choices (list) :visible t :modifiable-groups '(:author) :new-objects-first nil :sql-length 0 :nb-decimals 0 :get-value-sql "" :html-tag-attributes '(:rows "10") :view-type :medit)) (:user-name (make-instance 'meta-level:translated-string :en "Slide") :guid 3 :short-description 'title)))

(prog1 (meta-level:defclass presentation nil ((title :value-type string :user-name (make-instance 'meta-level:translated-string :en "Title") :choices (list) :visible t :modifiable-groups '(:author) :new-objects-first nil :sql-length 0 :nb-decimals 0 :get-value-sql "" :view-type :default) (slides :value-type slide :user-name (make-instance 'meta-level:translated-string :en "Slides") :choices (list) :visible t :modifiable-groups '(:author) :list-of-values t :new-objects-first nil :sql-length 0 :nb-decimals 0 :can-create-new-object t :get-value-sql "" :view-type :list-val)) (:user-name (make-instance 'meta-level:translated-string :en "Presentation") :guid 4 :short-description 'title)))

