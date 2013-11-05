;;; vc-clearcase-auto.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads (vc-clearcase-start-view vc-clearcase-edcs vc-clearcase-list-view-private-files
;;;;;;  vc-clearcase-label-diff-report vc-clearcase-update-view vc-clearcase-list-checkouts
;;;;;;  ah-clearcase-cleartool-program vc-clearcase) "vc-clearcase"
;;;;;;  "vc-clearcase.el" (17818 18320))
;;; Generated autoloads from vc-clearcase.el

(let ((loads (get (quote vc-clearcase) (quote custom-loads)))) (if (member (quote "vc-clearcase") loads) nil (put (quote vc-clearcase) (quote custom-loads) (cons (quote "vc-clearcase") loads))))

(defvar ah-clearcase-cleartool-program "cleartool" "\
The name of the cleartool executable.")

(custom-autoload (quote ah-clearcase-cleartool-program) "vc-clearcase" t)
(defun vc-clearcase-registered (file)
 (let (wdview
       retcode
       (program ah-clearcase-cleartool-program))
   (setq wdview
         (with-output-to-string
           (with-current-buffer standard-output
             (setq retcode
                   (call-process
                    program nil t nil "pwv" "-short" "-wdview")))))
   ;;(message "Wdview for %s is %S" file wdview)
   (if (or (not (eq retcode 0))
           (eq (compare-strings "** NONE **" 0 10 wdview 0 10) t))
       nil
     (load "vc-clearcase")
     (vc-clearcase-registered file))))

(autoload (quote vc-clearcase-list-checkouts) "vc-clearcase" "\
List the checkouts of the current user in DIR.
If PREFIX-ARG is present, an user name can be entered, and all
the views are searched for checkouts of the specified user.  If
the entered user name is empty, checkouts from all the users on
all the views are listed.

\(fn DIR &optional PREFIX-ARG)" t nil)

(autoload (quote vc-clearcase-update-view) "vc-clearcase" "\
Run a cleartool update command in DIR and display the results.
With PREFIX-ARG, run update in preview mode (no actual changes
are made to the views).

\(fn DIR PREFIX-ARG)" t nil)

(autoload (quote vc-clearcase-label-diff-report) "vc-clearcase" "\
Report the changed file revisions between labels.
A report is prepared in the *label-diff-report* buffer for the
files in `dir' that have different revisions between `label-1'
and `label-2'.

\(fn DIR LABEL-1 LABEL-2)" t nil)

(autoload (quote vc-clearcase-list-view-private-files) "vc-clearcase" "\
List the view private files in DIR.
You can edit the files using 'find-file-at-point'

\(fn DIR)" t nil)

(autoload (quote vc-clearcase-edcs) "vc-clearcase" "\
Fetch the config spec for VIEW-TAG and pop up a buffer with it.
In interactive mode, prompts for a view-tag name with the default
of the current file's view-tag.

\(fn VIEW-TAG)" t nil)

(autoload (quote vc-clearcase-start-view) "vc-clearcase" "\
Start the dynamic view for VIEW-TAG.
In interactive mode, prompts for a view-tag name.

\(fn VIEW-TAG)" t nil)

(define-key vc-prefix-map "e" (quote vc-clearcase-edcs))

(define-key vc-prefix-map "f" (quote vc-clearcase-start-view))

(define-key vc-prefix-map "j" (quote vc-clearcase-gui-vtree-browser))

(define-key vc-prefix-map "o" (quote vc-clearcase-list-checkouts))

(define-key vc-prefix-map "p" (quote vc-clearcase-update-view))

(define-key vc-prefix-map "t" (quote vc-clearcase-what-view-tag))

(define-key vc-prefix-map "w" (quote vc-clearcase-what-rule))

(define-key vc-prefix-map "y" (quote vc-clearcase-what-version))

(define-key-after vc-menu-map [separator-clearcase] (quote ("----")) (quote separator2))

(define-key-after vc-menu-map [vc-clearcase-what-version] (quote ("Show file version" . vc-clearcase-what-version)) (quote separator2))

(define-key-after vc-menu-map [vc-clearcase-what-rule] (quote ("Show configspec rule" . vc-clearcase-what-rule)) (quote separator2))

(define-key-after vc-menu-map [vc-clearcase-what-view-tag] (quote ("Show view tag" . vc-clearcase-what-view-tag)) (quote separator2))

(define-key-after vc-menu-map [vc-clearcase-gui-vtree-browser] (quote ("Browse version tree (GUI)" . vc-clearcase-gui-vtree-browser)) (quote separator2))

(defvar clearcase-global-menu (let ((m (make-sparse-keymap "Clearcase"))) (define-key m [vc-clearcase-label-diff-report] (quote (menu-item "Label diff report..." vc-clearcase-label-diff-report :help "Report file version differences between two labels"))) (define-key m [separator-clearcase-1] (quote ("----" (quote separator-1)))) (define-key m [vc-clearcase-list-view-private-files] (quote (menu-item "List View Private Files..." vc-clearcase-list-view-private-files :help "List view private files in a directory"))) (define-key m [vc-clearcase-list-checkouts] (quote (menu-item "List Checkouts..." vc-clearcase-list-checkouts :help "List Clearcase checkouts in a directory"))) (define-key m [vc-clearcase-update-view] (quote (menu-item "Update snapshot view..." vc-clearcase-update-view :help "Update a snapshot view"))) (define-key m [vc-clearcase-edcs] (quote (menu-item "Edit Configspec..." vc-clearcase-edcs :help "Edit a view's configspec"))) (define-key m [vc-clearcase-start-view] (quote (menu-item "Start dynamic view..." vc-clearcase-start-view :help "Start a dynamic view"))) (fset (quote clearcase-global-menu) m)))

(define-key-after menu-bar-tools-menu [ah-clearcase] (quote (menu-item "Clearcase" clearcase-global-menu)) (quote vc))

(if (boundp (quote vc-handled-backends)) (unless (memq (quote CLEARCASE) vc-handled-backends) (setq vc-handled-backends (nconc vc-handled-backends (quote (CLEARCASE))))) (setq vc-handled-backends (quote (RCS CVS CLEARCASE))))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; End:
;;; vc-clearcase-auto.el ends here
