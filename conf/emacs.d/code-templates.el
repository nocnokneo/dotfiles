;;
;; Doxygen function header
;;
(defun insert-c-function-header ()
  "Inserts a C function header"
  (interactive)
  (let (brief paramtag paramname paramdir paramdesc return pre post)
    (setq brief (read-from-minibuffer "Brief Description: "))
    (insert "/**")
    (insert-comment-tag "brief" brief)
    (setq paramname (read-from-minibuffer "Parameter Name: "))
    (while (> (length paramname) 0)
	   (progn
	    (setq paramdir (read-from-minibuffer "Parameter Direction (\"in\",\
\"out\", or \"in,out\"): "))
	    (setq paramdesc (read-from-minibuffer "Parameter Description: "))
	    (if (> (length paramdir) 0)
		(setq paramtag (concat "param[" paramdir "]"))
	      (setq paramtag "param")
	      )
	    (insert-comment-tag paramtag paramname paramdesc)
	    (setq paramname (read-from-minibuffer "Parameter Name: ")))
	   )
    (setq return (read-from-minibuffer "Return: "))
    (setq pre (read-from-minibuffer "Preconditions: "))
    (setq post (read-from-minibuffer "Postconditions: "))

    (insert-comment-tag "return" return)
    (insert-comment-tag "pre" pre)
    (insert-comment-tag "post" post)
    (insert "/")
    )
  )

(defun insert-comment-tag (tag text &optional text2)
  "Insert a javadoc (doxygen compatible) comment tag at the current
point in the form: \" * @tag text\""
  (let (start-point end-point)
    (if (> (length text) 0)
	(progn
	  (insert "\n")
	  (setq start-point (point))
	  (insert " * @")
	  (insert tag)
	  (insert " ")
	  (insert text)
	  (if (not (null text2))
	      (progn
		(insert " ")
		(insert text2)
		)
	    )
	  (setq end-point (point))
	  (fill-region start-point end-point)
;; 	  (fill-paragraph nil)
	  (insert "\n *")
;; 	  (setq end-of-tag-point (point))
;; 	  (goto-char end-of-tag-point)
	  )
      )
    )
  )
