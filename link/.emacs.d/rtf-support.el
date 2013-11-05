;;; rtf-support.el --- MS Rich Text Format support functions

;; Authors:    1999 Alastair J. Houghton <ajhoughton@lineone.net>
;; Keywords:   RTF Microsoft Windows NT
;; Version:    1.1

(defconst rtf-version "1.1"
  "RTF-support version number.")

;;; Customisation support     

;;;###autoload
(defgroup rtf nil
  "Copy RTF to the Windows clipboard"
  :group 'wp
  :tag "RTF")

;; This says whether to untabify the text before changing it to RTF
(defcustom rtf-untabify-p t
  "Set this to untabify the text before changing it to RTF.
This is for compatibility with broken wordprocessors (i.e. Microsoft Word)
that can't handle character-based tabs."
  :type 'boolean
  :group 'rtf)

(defcustom rtf-create-colours nil
  "Non-nil causes RTF output to contain new colours.
This is for compatibility with RTF readers that do not expect anything
but the standard set of colours (e.g. Microsoft Word). If new colours are
not being created, face colours are best-matched with those in the default
colour table `rtf-default-colour-table' using a Euclidean distance metric."
  :type 'boolean
  :group 'rtf)

;; This is the default colour table for the RTF output. It is set-up the
;; same way as Microsoft Word's default colour table, which means that
;; the colours won't cause too much bother.
(defcustom rtf-default-colour-table '((nil           . 0)    ;; Auto
				      ((0 0 0)       . 1)    ;; Black
				      ((0 0 255)     . 2)    ;; Blue
				      ((0 255 255)   . 3)    ;; Cyan
				      ((0 255 0)     . 4)    ;; Green
				      ((255 0 255)   . 5)    ;; Magenta
				      ((255 0 0)     . 6)    ;; Red
				      ((255 255 0)   . 7)    ;; Yellow
				      ((255 255 255) . 8)    ;; White
				      ((0 0 128)     . 9)    ;; Dark Blue
				      ((0 128 128)   . 10)   ;; Dark Cyan
				      ((0 128 0)     . 11)   ;; Dark Green
				      ((128 0 128)   . 12)   ;; Dark Magenta
				      ((128 0 0)     . 13)   ;; Dark Red
				      ((128 128 0)   . 14)   ;; Dark Yellow
				      ((128 128 128) . 15)   ;; Grey
				      ((192 192 192) . 16))  ;; Light Grey
  "The default colour table to use in RTF output.
This is the palette of colours that is used when rtf-create-colours is nil;
by default it matches the standard set used in Microsoft Word.

It is only used when `rtf-create-colours' is nil, in which case Emacs face
colours are matched with available palette colours by minimising the
Euclidean distance between the selected palette colour and the face colour.

Ideally, the indices should be unique, although that isn't enforced here
because it's possible that someone might find a use for non-unique indices
(in conjunction with the various broken programs that are about)."
  :type '(repeat rtf-color-table-entry)
  :group 'rtf)

(define-widget 'rtf-color-table-entry 'default
  "Edit an RTF colour table entry."
  :format "%v"
  :value '(nil . 0)
  :value-create 'rtf-color-table-value-create
  :value-delete 'widget-children-value-delete
  :value-get 'rtf-color-table-value-get
  :value-set 'rtf-color-table-value-set
  :match '(lambda (widget value) t)
  :validate 'widget-children-validate
  :convert-widget 'widget-value-convert-widget)

(defun rtf-color-table-value-create (widget)
  "Create the components of an rtf-color-table-entry widget."
  (let ((value (widget-get widget :value))
	index color)
    (setq index (widget-create-child-value widget
					   '(integer
					     :tag "Index"
					     :size 6)
					   (cdr value)))
    (insert ?\ )
    (setq color (widget-create-child-value widget
					   '(rtf-color
					     :tag "Color")
					   (car value)))
    (insert ?\n)
    (widget-put widget :children (list index color))
    ))

(defun rtf-color-table-value-get (widget)
  "Retrieve the value of an rtf-color-table-entry widget."
  (let ((children (widget-get widget :children)))
    (if children
	(cons (widget-value (cadr children))
	      (widget-value (car children)))
      (widget-get widget :value))))

(defun rtf-color-table-value-set (widget value)
  "Set the value of an rtf-color-table-entry widget."
  (let ((children (widget-get widget :children)))
    (if children
	(progn
	  (widget-value-set (car children) (cdr value))
	  (widget-value-set (cadr children) (car value))))))

(define-widget 'rtf-color 'editable-field
  "Choose a color, either (R G B) or auto (with sample)."
  :format "%{%t%}: (%{  %}) %v"
  :size 15
  :tag "Color"
  :value nil
  :sample-face-get 'rtf-color-sample-face-get
  :notify 'rtf-color-notify
  :action 'rtf-color-action
  :error "Must be an RGB triple (R G B), or auto."
  :validate 'rtf-color-validate
  :match 'rtf-color-match
  :value-to-internal 'rtf-color-value-to-internal
  :value-to-external 'rtf-color-value-to-external)

(defun rtf-color-as-string (color)
  "Get a color as a string."
  (if (and color
	   (not (eq color 'rtf-invalid-color)))
      (format "#%2.2X%2.2X%2.2X" (car color) (cadr color) (caddr color))
    "#000000"))

(defun rtf-color-sample-face-get (widget)
  "Retrieve the sample face."
  (or (widget-get widget :sample-face)
      (let ((color (widget-value widget))
	    (face (make-face (gensym "sample-face-") nil t)))
	(widget-put widget :sample-face face)
	(if (rtf-color-match widget color)
	    (set-face-background face (rtf-color-as-string color))
	  (set-face-background face "#000000"))
	face)))

(defun rtf-color-action (widget &optional event)
  "Prompt for a colour."
  (let* ((tag (widget-apply widget :menu-tag-get))
	 (answer (read-string (concat tag ": ")
			      (rtf-color-value-to-internal
			       widget
			       (widget-value widget)))))
    (unless (zerop (length answer))
      (widget-value-set widget (rtf-color-value-to-external widget answer))
      (widget-setup)
      (widget-apply widget :notify widget event))))

(defun rtf-color-notify (widget child &optional event)
  "Update the sample, and notify the parent."
  (let* ((face (widget-apply widget :sample-face-get))
	 (color (widget-value widget)))
    (if (rtf-color-match widget color)
	(set-face-background face (rtf-color-as-string color))
      (set-face-background face "#000000"))
  (widget-default-notify widget child event)))

(defun rtf-color-validate (widget)
  "Validate this widget's value."
  (let ((color (widget-value widget)))
    (if (rtf-color-match widget color)
	nil
      widget)))

(defun rtf-color-match (widget value)
  "Validate this value."
  (and (not (eq value 'rtf-invalid-color))
       (or (not value)
	   (and (listp value)
		(eq (length value) 3)))))

(defun rtf-color-value-to-internal (widget value)
  "Convert to internal representation (string)."
  (cond
   ((eq value 'rtf-invalid-color)
    "auto")
   (value
    (format "(%d %d %d)" (car value) (cadr value) (caddr value)))
   (t
    "auto")))

(defun rtf-color-value-to-external (widget value)
  "Convert to external representation."
  (if (equal value "auto")
      nil
    (let ((val (condition-case nil
		   (read value)
		 (error nil))))
      (if (and (listp val)
	       (every '(lambda (x)
			 (and (integerp x)
			      (<= x 255)
			      (>= x 0)))
		      val))
	  val
	'rtf-invalid-color))
    ))

;;; Code proper:

;; This is the clipboard format ID
(defvar rtf-clipboard-format nil
  "Contains the mswindows clipboard format for RTF.")

(if rtf-clipboard-format
    ()
  (setq rtf-clipboard-format (mswindows-register-clipboard-format
			      "Rich Text Format")))

;; This function makes a string safe for inclusion in an RTF file
(defun rtf-safe (string)
  "Return a valid RTF string with the textual meaning of `string'.
This function makes various special characters safe by escaping them."
  (let ((tmp-string string)
	(out-string nil)
	next)
    (while tmp-string
      (setq next (string-match "[{}\\\\]" tmp-string))
      (if next
	  (progn
	    (setq out-string (concat out-string
				     (substring tmp-string 0 next)
				     "\\"
				     (substring tmp-string next (+ next 1))))
	    (setq tmp-string (substring tmp-string (+ next 1))))
	(setq out-string (concat out-string tmp-string))
	(setq tmp-string nil)))
    out-string))

(defun rtf-map-chars (string)
  "Map some characters in an RTF string."
  (let ((tmp-string (rtf-safe string))
	(out-string nil)
	next)
    (while tmp-string
      (setq next (string-match "\t" tmp-string))
      (if next
	  (progn
	    (setq out-string (concat out-string
				     (substring tmp-string 0 next)
				     "\\tab "))
	    (setq tmp-string (substring tmp-string (+ next 1))))
	(setq out-string (concat out-string tmp-string))
	(setq tmp-string nil)))
    (setq tmp-string out-string)
    (setq out-string nil)
    (while tmp-string
      (setq next (string-match "\n" tmp-string))
      (if next
	  (progn
	    (setq out-string (concat out-string
				     (substring tmp-string 0 next)
				     "\\par\n"))
	    (setq tmp-string (substring tmp-string (+ next 1))))
	(setq out-string (concat out-string tmp-string))
	(setq tmp-string nil)))
    out-string))

(defun rtf-map-colour (emacs-colour)
  "Convert an EMACS colour triple to a more suitable form for RTF."
  (list
   (max (min (/ (nth 0 emacs-colour) 256) 255) 0)
   (max (min (/ (nth 1 emacs-colour) 256) 255) 0)
   (max (min (/ (nth 2 emacs-colour) 256) 255) 0)))

(defun rtf-match-colour (colour colours best-match)
  "Find a colour in the colours list.
If `best-match' is non-nil, it matches the closest colour, otherwise
it performs an exact match."
  (if best-match
      (let (current
	    curcol
	    (bestcol nil)
	    (bestdist nil)
	    dist)
	;; Remember to skip the "auto" colour
	(setq current (cdr colours))
	(while current
	  (setq curcol (car current))
	  (setq current (cdr current))
	  (let ((rd (- (nth 0 colour) (nth 0 (car curcol))))
		(gd (- (nth 1 colour) (nth 1 (car curcol))))
		(bd (- (nth 2 colour) (nth 2 (car curcol)))))
	    (setq dist (sqrt (+ (* rd rd) (* gd gd) (* bd bd)))))
	  (if (or (not bestdist) (< dist bestdist))
	      (progn
		(setq bestdist dist)
		(setq bestcol (cdr curcol)))))
	bestcol)
    (cdr (assoc colour colours))))

;; This function generates a ruler
(defun rtf-ruler (tab-twips nstops)
  "Generate the RTF for a set of tab-stops, starting at the left margin,
separated by `tab-twips' twips, with `nstops' stops."
  (let ((result nil)
	(stops nstops)
	(pos 0))
    (while (> stops 0)
      (setq stops (- stops 1))
      (setq pos (truncate (+ pos tab-twips)))
      (setq result (concat result "\\tx" (number-to-string pos))))
    result)
  )

;; This function takes a region and generates RTF in the specified buffer
(defun rtf-spool-region (start end)
  "Spool a buffer as Microsoft Rich Text Format text.
Like `ps-spool-region', although the rtf-support code doesn't keep
track of spooled regions to despool (because RTF isn't useful for
printing). Returns the buffer containing the RTF."
  (interactive "r")
  ;; Swap if necessary
  (if (< end start)
      (let ((tmp start))
	(setq start end)
	(setq end tmp)))
  ;; Create the new buffer
  (let ((rtf-buf (generate-new-buffer "*rtf*"))
	(tmp-buf nil)
	old-buf)
    (save-excursion
      ;; Build the RTF header first
      (insert-string "{\\rtf1\\ansi" rtf-buf)
      ;; Build the font table, colour table and stylesheet
      (let ((fonts nil)
	    (colours rtf-default-colour-table)
	    (styles nil)
	    (fnum 0) (cnum 16) (snum 0)
	    (font nil) (forecolour nil) (backcolour nil)
	    (style nil) (extstyle nil)
	    (faces-list (face-list 'both))
	    (cur-face nil)
	    (current nil)
	    (curlist nil) (style-map nil)
	    (tab-twips 720))
	;; Enumerate the faces, breaking out lists
	(while (car faces-list)
	  (setq cur-face (car faces-list))
	  (setq faces-list (cdr faces-list))
	  ;; Extract font information
	  (setq font (font-name (face-property cur-face 'font)))
	  (setq font (split-string font ":"))
	  (setq font (list (nth 0 font)
			   (nth 1 font)
			   (nth 3 font)
			   (string-to-number (nth 2 font))))
	  ;; Make a new font if necessary
	  (if (assoc (nth 0 font) fonts)
	      ()
	    (setq fnum (+ fnum 1))
	    (setq fonts (append fonts (list (cons
					     (nth 0 font) fnum)))))

	  ;; Make new colours if necessary
	  (setq forecolour (rtf-map-colour
			    (color-rgb-components
			     (face-property cur-face 'foreground))))
	  (setq backcolour (rtf-map-colour
			    (color-rgb-components
			     (face-property cur-face 'background))))

	  (if rtf-create-colours
	      (progn
		(if (assoc forecolour colours)
		    ()
		  (setq cnum (+ cnum 1))
		  (setq colours (append colours
					(list
					 (cons forecolour cnum)))))
		
		(if (assoc backcolour colours)
		    ()
		  (setq cnum (+ cnum 1))
		  (setq colours (append colours
					(list
					 (cons backcolour cnum)))))
		))
	  
	  ;; Sort-out bold, underlined, etc...
	  (setq extstyle nil)
	  (let ((font-type (nth 1 font)))
	    (if (string-match "Bold" font-type)
		(setq extstyle (concat "\\b" extstyle)))
	    (if (string-match "Italic" font-type)
		(setq extstyle (concat "\\i" extstyle)))
	    (if (face-underline-p cur-face)
		(setq extstyle (concat "\\ul" extstyle)))
	     )
	     
	  ;; Make a new style for this face
	  (setq style (list (format "(EMACS) %s" cur-face)
			    (cdr (assoc (nth 0 font) fonts))
			    (nth 3 font)
			    (rtf-match-colour forecolour colours
					      (not rtf-create-colours))
			    (rtf-match-colour backcolour colours
					      (not rtf-create-colours))
			    extstyle
			    cur-face))

	  ;; If this was the default face, work-out how big a tab is
	  (if rtf-untabify-p
	      ()
	    (if (equal (nth 0 style) "(EMACS) default")
		(let ((fwidth (font-instance-width
			       (specifier-instance
				(face-property cur-face 'font)))))
		  (setq tab-twips (* fwidth 8))
		  )))

	  (setq snum (+ snum 1))
	  (setq styles (append styles (list (cons style snum))))
	  )

	;; OK - emit the font table
	(insert-string "{\\fonttbl" rtf-buf)

	(setq curlist fonts)
	(while (setq current (car curlist))
	  (setq curlist (cdr curlist))
	  (insert-string (concat "\\f" (number-to-string (cdr current))
				 "\\fmodern "
				 (car current) ";") rtf-buf))

	;; Now emit the colour table
	(insert-string "}\n{\\colortbl;" rtf-buf)

	(setq curlist colours)
	(while (setq current (car curlist))
	  (setq curlist (cdr curlist))
	  (if (car current)
	      (insert-string (concat
			      "\\red" (number-to-string (nth 0 (car current)))
			      "\\green" (number-to-string (nth 1 (car current)))
			      "\\blue" (number-to-string (nth 2 (car current)))
			      ";") rtf-buf)))
			   
	;; Finally do the stylesheet
	(insert-string "}\n{\\stylesheet" rtf-buf)

	(setq curlist styles)
	(while (setq current (car curlist))
	  (setq curlist (cdr curlist))
	  (if (equal (nth 0 (car current)) "(EMACS) default")
	      (progn
		(insert-string (concat
				"\\s0"
				"{\\plain\\f" (number-to-string
					       (nth 1 (car current)))
				"\\fs" (number-to-string
					(* (nth 2 (car current)) 2))
				"\\cf" (number-to-string (nth 3 (car current)))
				"\\cb" (number-to-string (nth 4 (car current)))
				"\\lang1024"
				(nth 5 (car current))
				(rtf-ruler tab-twips 30)
				" EMACS Text;}"
				"\\*\\cs0"
				"{\\plain\\f" (number-to-string
					       (nth 1 (car current)))
				"\\fs" (number-to-string
					(* (nth 2 (car current)) 2))
				"\\cf" (number-to-string (nth 3 (car current)))
				"\\cb" (number-to-string (nth 4 (car current)))
				"\\lang1024"
				(nth 5 (car current))
				" EMACS Base Style;}") rtf-buf)
		(setq style-map (append style-map
				  (list (cons nil
					 (concat
					  "\\*\\cs0"
					  "\\f" (number-to-string
						 (nth 1 (car current)))
					  "\\fs" (number-to-string
						  (* (nth 2 (car current)) 2))
					  "\\cf" (number-to-string
						  (nth 3 (car current)))
					  "\\cb" (number-to-string
						  (nth 4 (car current)))
					  "\\lang1024"
					  (nth 5 (car current)))
					 ))
				  )))
	  (insert-string (concat
			  "\\*\\cs" (number-to-string (cdr current))
			  "{\\f" (number-to-string (nth 1 (car current)))
			  "\\fs" (number-to-string (* (nth 2 (car current)) 2))
			  "\\cf" (number-to-string (nth 3 (car current)))
			  "\\cb" (number-to-string (nth 4 (car current)))
			  "\\lang1024"
			  (nth 5 (car current))
			  "\\sbasedon0 "
			  (nth 0 (car current))
			  ";}") rtf-buf)
	  (setq style-map (append style-map
				  (list (cons (nth 6 (car current))
					 (concat
					  "\\*\\cs"
					  (number-to-string (cdr current))
					  "\\f" (number-to-string
							(nth 1 (car current)))
					  "\\fs" (number-to-string
						  (* (nth 2 (car current)) 2))
					  "\\cf" (number-to-string
						  (nth 3 (car current)))
					  "\\cb" (number-to-string
						  (nth 4 (car current)))
					  "\\lang1024"
					  (nth 5 (car current)))
					 ))
				  ))
	  ))
	
	;; End the header
	(insert-string (concat "}\n{\\plain\\s0"
			       (rtf-ruler tab-twips 30)
			       "{\\*\\cs0"
			       (cdr (assoc nil style-map))) rtf-buf)

	;; Go through all the extents writing out the text and the style changes
	(setq old-buf (current-buffer))
	
	(if rtf-untabify-p
	    (progn
	      (setq tmp-buf (generate-new-buffer "*rtf-tmp*"))
	      (let ((old-tab-width tab-width)
		    (all-extents (extent-list))
		    cur-extent)
		(set-buffer tmp-buf)
		(setq tab-width old-tab-width)
		(insert-buffer old-buf)
		(while (setq cur-extent (car all-extents))
		  (setq all-extents (cdr all-extents))
		  (insert-extent cur-extent (extent-start-position cur-extent)
				 (extent-end-position cur-extent))))
	      (let (start-line start-column end-line end-column)
		(goto-char start)
		(setq start-column (current-column))
		(setq start-line (+ (count-lines 1 (point))
				     (if (= start-column 0) 1 0)))
		(goto-char end)
		(setq end-column (current-column))
		(setq end-line (+ (count-lines 1 (point))
				  (if (= end-column 0) 1 0)))
		(untabify (point-min) (point-max))
		(goto-line start-line)
		(forward-char start-column)
		(setq start (point))
		(goto-line end-line)
		(forward-char end-column)
		(setq end (point))
	      )))
	
	(let ((pos start))
	  (while (< pos end)
	    (let ((next-change
		   (or (next-single-property-change pos 'face)
		       end))
		  (formatting (cdr (assoc
				    (get-text-property pos 'face) style-map))))
	      (if formatting
		  (insert-string (concat
				  "{" formatting
				  " "
				  (rtf-map-chars (buffer-string pos
								next-change))
				  "}")
				 rtf-buf)
		(insert-string (rtf-map-chars (buffer-string pos next-change))
			       rtf-buf))
	      (setq pos next-change)
	      )))

	(set-buffer old-buf)
	
	;; Delete temporary buffer
	(if rtf-untabify-p
	    (kill-buffer tmp-buf))
	
	;; End the file
	(insert-string "\\par\n}}}" rtf-buf)
	))
    rtf-buf
    ))

(defun rtf-spool-buffer ()
  "Spool the entire buffer."
  (interactive)
  (rtf-spool-region 1 (buffer-size)))

;;; Functions users are most likely to use

(defun rtf-export (filename)
  "Export the current document as RTF, preserving faces."
  (interactive "FExport RTF: ")
  (let ((rtf-buf (rtf-spool-buffer)))
    (save-excursion
      (set-buffer rtf-buf)
      (write-file filename t))
    (kill-buffer rtf-buf)))

(defun rtf-export-region (filename start end)
  "Export the selected region as RTF, preserving faces."
  (interactive "FExport RTF: \nr")
  (let ((rtf-buf (rtf-spool-region start end)))
    (save-excursion
      (set-buffer rtf-buf)
      (write-file filename t))
    (kill-buffer rtf-buf)))

(defun rtf-clip-buffer ()
  "Send the entire buffer to the clipboard as Rich Text Format. The function
also copies the buffer as ordinary text, just for consistency."
  (interactive)
  (let ((rtf-buf (rtf-spool-buffer)))
    (mswindows-set-clipboard (buffer-string 1 (+ 1 (buffer-size))))
    (mswindows-set-clipboard (buffer-string nil nil rtf-buf)
			     rtf-clipboard-format t)
    (kill-buffer rtf-buf)))

(defun rtf-clip-region (start end)
  "Send the specified region (the selection if called interactively) to the
clipboard as Rich Text Format. The function also copies the region in ordinary
text, just for consistency."
  (interactive "r")
  (let ((rtf-buf (rtf-spool-region start end)))
    (mswindows-set-clipboard (buffer-string start end))
    (mswindows-set-clipboard (buffer-string nil nil rtf-buf)
			     rtf-clipboard-format t)
    (kill-buffer rtf-buf)))

;;; Provides RTF support

(provide 'rtf-support)
