(in-package #:slides)

(defun obj-url (obj &optional view (page "object"))
  (interface::encode-object-url
   obj :args `(,@(when view `(:view ,view)) :page ,page)))

(defmethod insert-page-title ((app slides-app) page)
  (html:html "CL-Slides - " (webapp::name page)))

(defmethod insert-html-head-links ((app slides-app) page)
  (html:html
     ((:link :rel "shortcut icon" :href "/static/favicon.png" :type "image/png"))
     ((:link :rel "stylesheet" :href "/static/bootstrap/bootstrap.min.css"))
     ((:link :rel "stylesheet" :href "/static/bootstrap/bootstrap-theme.min.css"))
     ((:link :rel "stylesheet" :href "/static/libs/bs-datetimepicker/bootstrap-datetimepicker.min.css"))
     ((:link :rel "stylesheet" :href "/static/css/fcweb-bs.css"))
;     ((:script :src "https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"))
     ((:script :src "/static/jquery/jquery.js"))
     ((:script :src "/static/bootstrap/bootstrap.min.js"))
     ((:script :src "/static/libs/moment.js/moment.min.js"))
     ((:script :src "/static/libs/bs-datetimepicker/bootstrap-datetimepicker.min.js"))
     (:comment
      "[if lt IE 9]>
      <script src=\"https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js\"></script>
      <script src=\"https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js\"></script>
    <![endif]")
     (:comment " Custom styles")
     ((:link :href "/static/css/carousel.css" :rel "stylesheet"))
     #+nil((:script :src "/static/fgt.js"))
     ((:script :src "/static/fractal.js"))))

(defmethod ensure-user ((app slides-app))
  (unless *user*
    (switch-user (make-instance 'slides-user :store meta::*memory-store*))))

(defmethod find-user-by-user-name ((app slides-app) user-name)
  (find user-name (users app) :key 'user-name :test #'string=))

(defmethod find-user-by-cookie ((app slides-app) cookie)
  (find cookie (users app) :key 'cookie :test #'string=))

(defmethod link-user-cookie ((user slides-user) cookie)
  (setf (cookie user) cookie))

(defmethod create-new-user ((app slides-app) user-name)
  (let ((user (make-instance 'slides-user :parent app)))
    (setf (user-name user) user-name)
    (push user (users app))
    user))

(defmethod insert-navbar ((app slides-app) page)
  (html:html
   (insert-login-dialog app page)
   ((:div :class "navbar-wrapper")
    ((:div :class "container-fluid")
     ((:div :class "navbar navbar-inverse navbar-fixed-top" :role "navigation")
      ((:div :class "container")
       ((:div :class "navbar-header")
        ((:button :type "button" :class "navbar-toggle" :data-toggle "collapse" :data-target ".navbar-collapse")
         ((:span :class "sr-only") "Toggle navigation")
         ((:span :class "icon-bar"))
         ((:span :class "icon-bar"))
         ((:span :class "icon-bar")))
        ((:a :class "navbar-brand" :href #e"home") ((:img :class "brand" :src "/static/made-with-lisp-logo.jpg" :alt "CL-Slides"))))
       ((:div :class "navbar-collapse collapse")
        ((:ul :class "nav navbar-nav")
         ((:li :class "active") ((:a :href #e"home") "Home"))
         (:when-groups '(:admin)
            (:li ((:a :href (obj-url *app*)) "Administration")))
         (:li ((:a :href (obj-url *user* "usettings")) "My Settings"))
         (:li ((:a :href "#" #+nil #e"about") "About"))
         (:li ((:a :href "#" #+nil #e"contact") "Contact")))
        (insert-log-inout-button app page))))))))

(defmethod insert-jumbotron ((app slides-app) page)
  (html:html
   ((:div :class "jumbotron")
;    ((:div :class "jumbotron-inner"))
    (:h1 "How does this work?")
    (:p ((:a :class "btn btn-lg btn-success" :href "#" :role "button") "Learn more")))))

(defmethod insert-carousel ((app slides-app) page)
  (html:html
    ((:div :id "myCarousel" :class "carousel slide" :data-ride "carousel")
     (:comment " Indicators ")
     ((:ol :class "carousel-indicators")
      ((:li :data-target "#myCarousel" :data-slide-to "0" :class "active"))
      ((:li :data-target "#myCarousel" :data-slide-to "1"))
      ((:li :data-target "#myCarousel" :data-slide-to "2")))
     ((:div :class "carousel-inner")
      ((:div :class "item active")
       ((:img :src "/static/image2.jpg" :alt "First slide"))
       ((:div :class "container")
        ((:div :class "carousel-caption")
         (:h1 "How it works.")
         (:p "text...")
         (:p ((:a :class "btn btn-lg btn-success" :href "#" :role "button") "Learn more")))))
      ((:div :class "item")
       ((:img :src "/static/home-img2.jpg" :alt "Second slide"))
       ((:div :class "container")
        ((:div :class "carousel-caption")
         (:h1 "Register for a dinner")
         (:p ((:a :class "btn btn-lg btn-primary" :href "#" :role "button") "Sign up today")))))
      ((:div :class "item")
       ((:img :src "/static/home-img3.jpg" class "img-responsive" :alt "Third slide"))
       ((:div :class "container")
        ((:div :class "carousel-caption")
         (:h1 "Organize your own slides dinner.")
         (:p ((:a :class "btn btn-lg btn-primary" :href "#" :role "button") "Learn more"))))))
     ((:a :class "left carousel-control" :href "#myCarousel" :data-slide "prev")
      ((:span :class "glyphicon glyphicon-chevron-left")))
     ((:a :class "right carousel-control" :href "#myCarousel" :data-slide "next")
       ((:span :class "glyphicon glyphicon-chevron-right"))))))

(defun marketing-home-page (app page)
    (insert-jumbotron app page)
;  (insert-carousel app page)
  (html:html
   ((:Div :class "container marketing")
    ((:div :class "row")
     ((:div :class "col-lg-4")
      ((:img :class "img-circle" :data-src "holder.js/140x140" :alt "Generic placeholder image"))
      (:h2 "Heading")
      (:p
       "Donec sed odio dui. Etiam porta sem malesuada magna mollis euismod. Nullam id dolor id nibh ultricies vehicula ut id elit. Morbi leo risus, porta ac consectetur ac, vestibulum at eros. Praesent commodo cursus magna.")
      (:p ((:a :class "btn btn-default" :href "#" :role "button") "View details &raquo;")))
     (:comment " /.col-lg-4 ")
     ((:div :class "col-lg-4")
      ((:img :class "img-circle" :data-src "holder.js/140x140" :alt "Generic placeholder image"))
      (:h2 "Heading")
      (:p
       "Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Cras mattis consectetur purus sit amet fermentum. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh.")
      (:p ((:a :class "btn btn-default" :href "#" :role "button") "View details &raquo;")))
     (:comment " /.col-lg-4 ")
     ((:div :class "col-lg-4")
      ((:img :class "img-circle" :data-src "holder.js/140x140" :alt "Generic placeholder image"))
      (:h2 "Heading")
      (:p
       "Donec sed odio dui. Cras justo odio, dapibus ac facilisis in, egestas eget quam. Vestibulum id ligula porta felis euismod semper. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus.")
      (:p ((:a :class "btn btn-default" :href "#" :role "button") "View details &raquo;")))
     (:comment " /.col-lg-4 "))
    (:comment " /.row ")
    (:comment " START THE FEATURETTES ")
    ((:hr :class "featurette-divider"))
    ((:div :class "row featurette")
     ((:div :class "col-md-7")
      ((:h2 :class "featurette-heading") "First featurette heading. " ((:span :class "text-muted") "It'll blow your mind."))
      ((:p :class "lead")
       "Donec ullamcorper nulla non metus auctor fringilla. Vestibulum id ligula porta felis euismod semper. Praesent commodo cursus magna, vel scelerisque nisl consectetur. Fusce dapibus, tellus ac cursus commodo."))
     ((:div :class "col-md-5")
      ((:img :class "featurette-image img-responsive" :data-src "holder.js/500x500/auto" :alt "Generic placeholder image"))))
    ((:hr :class "featurette-divider"))
    ((:div :class "row featurette")
     ((:div :class "col-md-5")
      ((:img :class "featurette-image img-responsive" :data-src "holder.js/500x500/auto" :alt "Generic placeholder image")))
     ((:div :class "col-md-7")
      ((:h2 :class "featurette-heading") "Oh yeah, it's that good. " ((:span :class "text-muted") "See for yourself."))
      ((:p :class "lead")
       "Donec ullamcorper nulla non metus auctor fringilla. Vestibulum id ligula porta felis euismod semper. Praesent commodo cursus magna, vel scelerisque nisl consectetur. Fusce dapibus, tellus ac cursus commodo.")))
    ((:hr :class "featurette-divider"))
    ((:div :class "row featurette")
     ((:div :class "col-md-7")
      ((:h2 :class "featurette-heading") "And lastly, this one. " ((:span :class "text-muted") "Checkmate."))
      ((:p :class "lead")
       "Donec ullamcorper nulla non metus auctor fringilla. Vestibulum id ligula porta felis euismod semper. Praesent commodo cursus magna, vel scelerisque nisl consectetur. Fusce dapibus, tellus ac cursus commodo."))
     ((:div :class "col-md-5")
      ((:img :class "featurette-image img-responsive" :data-src "holder.js/500x500/auto" :alt "Generic placeholder image"))))
    ((:hr :class "featurette-divider"))
    :connect)))

(defmethod write-page ((app slides-app) (page home-page-desc))
  (html:html
   (:doctype)
   (:html
    (:head
     (:title (insert-page-title app page))
     (insert-html-meta app page)
     (insert-html-head-links app page))
    (:body
     (wa::insert-global-modal app page)
     (insert-navbar app page)
     (:if *authenticated*
          ((:div :class "container-fluid")
       #+nil    (:when-groups '(:admin)
                (:object-view :object *app*))
           (:unless-groups '(:admin)
                (:object-view :object *user* :name "dashboard"))
           :connect-views)
          (marketing-home-page app page))
     (:footer
      ((:p :class "pull-right") ((:a :href "#") "Back to top"))
      (:p "&copy; 2014 Marc Battyani. &middot; " ((:a :href "#") "Privacy") " &middot; " ((:a :href "#") "Terms")))))))

(defmethod write-page ((app slides-app) (page obj-page-desc))
  (html:html
   (:doctype)
   (:html
    (:head
     (:title (insert-page-title app page))
     (insert-html-meta app page)
     (insert-html-head-links app page))
    (:body
     (wa::insert-global-modal app page)
     (insert-navbar app page)
     (:if *authenticated*
          ((:div :class "container-fluid")
           (gen-breadcrumbs app page *object*)
           (:object-view)
           :connect-views)
          (interface::redirect-to #e"home" *request*))
     (:footer
      ((:p :class "pull-right") ((:a :href "#") "Back to top"))
      (:p "&copy; 2014 Marc Battyani. &middot; " ((:a :href "#") "Privacy") " &middot; " ((:a :href "#") "Terms")))))))

(defmethod write-page ((app slides-app) (page raw-page-desc))
  (html:html
   (:doctype)
   (:html
    (:head
     (:title (insert-page-title app page))
     (insert-html-meta app page)
     (insert-html-head-links app page)
     ((:link :rel "stylesheet" :href "/static/slides.css"))
     ((:script :src "/static/slides.js")))
    (:body
     (:object-view)
     :connect-views))))
