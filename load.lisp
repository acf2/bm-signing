;;;; load.lisp

(ql:quickload :ironclad :silent t)
(ql:quickload :babel :silent t)
(ql:quickload :apply-argv :silent t)

(defparameter work-dir (directory-namestring (or *load-truename* *default-pathname-defaults*)))

(pushnew work-dir
         asdf:*central-registry*
         :test #'equal)

(with-open-stream (*standard-output* (make-broadcast-stream))
  (asdf:load-system :bm-signing))
