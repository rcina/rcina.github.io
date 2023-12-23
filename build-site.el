;; Set the package installation directory so that packages aren't stored in the
;; ~/.emacs.d/elpa path
(require 'package)
(setq package-user-dir (expand-file-name "./.packages"))
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;; Initialize the package system
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install dependencies
(package-install 'htmlize)

;; Load the publishing system
(require 'ox-publish)

(setq org-html-validation-link nil   ;; Don't show validation link
      org-html-head-include-scripts nil  ;; Use our own scripts
      org-html-head-include-default-style nil ;; Use our own styles
      org-html-htmlize-output-type 'css
      ;;org-html-head "<link rel=\"stylesheet\" href=\"https://cdn.simplecss.org/simple.min.css\" />"
      org-html-head "<link rel=\"stylesheet\" href=\"simple.css\" />"
      )

;; Define the publishing project
(setq org-publish-project-alist
      (list
       (list "Blog"
             :recursive t
             :base-directory "./content"
             :publishing-directory "./public"
             :publishing-function 'org-html-publish-to-html
             :with-author nil     ;; Don't include author name
             :with-creator t      ;; Include Emacs and Org versions in footer
             :with-toc nil        ;; Don't include a table of contents
             :section-numbers nil ;; Don't include section numbers
             :time-stamp-file nil))) ;; Don't include time stamp in file

(defvar yt-iframe-format
  ;; You may want to change your width and height.
  (concat "<iframe width=\"440\""
          " height=\"335\""
          " src=\"https://www.youtube.com/embed/%s\""
          " frameborder=\"0\""
          " allowfullscreen>%s</iframe>"))

(org-add-link-type
 "yt"
 (lambda (handle)
   (browse-url
    (concat "https://www.youtube.com/embed/"
            handle)))
 (lambda (path desc backend)
   (cl-case backend
     (html (format yt-iframe-format
                   path (or desc "")))
     (latex (format "\href{%s}{%s}"
                    path (or desc "video"))))))

;; generate the site output
(org-publish-all t)

(message "Build complete!")
