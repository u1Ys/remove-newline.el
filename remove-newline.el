;;
;; $Id: remove-newline.el 0.0 2020/48/04/10/20 11:04:20 u1 Exp u1 $
;;
;; (global-set-key "\M-Q" 'remove-newline)

(defvar remove-newline-replace "")
(defun toggle-remove-newline-language ()
  "Toggle remove-newline mode between English and Japanese"
  (interactive)
  (let*
      ((jp (eq remove-newline-replace "")))
    (message (concat "Set remove-newline mode to " (if jp "EN" "JP")))
    (setq remove-newline-replace (if jp " " ""))
    )
  )

(defun _remove-newline (start end)
  (replace-regexp "\n *" remove-newline-replace nil start end)
  ;; (save-restriction
  ;;   (narrow-to-region start end)
  ;;   (goto-char (point-min))
  ;;   (while (search-forward "^ *" nil t) (replace-match replace nil t)))
  )

(defun _remove-newline-paragraph ()
  (save-excursion
    (let
	((start (progn
		  ;; Move cursor to end of line, because
		  ;; backward-paragraph moves cursor to previous
		  ;; paragraph if cursor on beginning of line
		  (end-of-line)
		  (if (eq major-mode 'org-mode)
		      (org-backward-paragraph) (backward-paragraph))
		  (point)
		  ))
	 (end (progn
		(if (eq major-mode 'org-mode)
		    (org-forward-paragraph) (forward-paragraph))
		(backward-word)
		(point)
		)))
      (_remove-newline start end)
      ))
  )

(defun remove-newline ()
  "Remove newlines. If region is selected, remove newlines in
region. If region is *not* selected, remove newlines in a
paragraph"
  (interactive)
  (if mark-active
      (_remove-newline (point) (mark))
    (_remove-newline-paragraph))
  )

(provide 'remove-newline)
