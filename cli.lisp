(defparameter argv (apply-argv:parse-argv (loop for elem in (rest *posix-argv*)
                                                collect (coerce elem 'string))))
(defparameter current-dir (pathname-directory *default-pathname-defaults*))

(format t "~S~%" *posix-argv*)
(format t "~S~%" argv)
(format t "~S~%" current-dir)

(defun getf-int (p-list key)
  (when (getf p-list key)
    (parse-integer (getf p-list key) :junk-allowed t)))

(defmacro setf-if-not-nil (place value)
  `(when (not (null ,value))
     (setf ,place ,value)))

(setf-if-not-nil bellare-miner:*boundary* (getf-int argv :bits))
(setf-if-not-nil bellare-miner:*challenge-length* (getf-int argv :points))

(when (getf argv :generate-key)
  (let ((fail nil))
    (unless (getf argv :private-key)
      (format t "You should specify secret key filename for generation of the key~%")
      (setf fail t))
    (unless (getf argv :public-key)
      (format t "You should specify public key filename for generation of the key~%")
      (setf fail t))
    (unless (getf-int argv :time-periods)
      (format t "You should specify number of time periods for generation of the key~%")
      (setf fail t))
    (when fail (quit)))
  (let* ((time-periods (getf-int argv :time-periods))
         (key (bellare-miner:generate-key time-periods)))
    (with-standard-io-syntax
      (with-open-file (pub-out (getf argv :public-key) :direction :output :if-exists :supersede)
        (format pub-out "~S~%" (getf key :public-key)))
      (with-open-file (prv-out (getf argv :private-key) :direction :output :if-exists :supersede)
        (format prv-out "~S~%" (getf key :private-key))))))
