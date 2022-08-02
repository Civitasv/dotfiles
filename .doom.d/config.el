;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Civitasv"
      user-mail-address "hscivitasv@gmail.com")

(setq-default
 delete-by-moving-to-trash t       ; Delete files to trash
 window-combination-resize t       ; take new window space from all other windows
 x-stretch-cursor t)               ; stretch cursor to the glyph width

(setq undo-limit 80000000          ; Raise undo-limit to 80Mb
      evil-want-fine-undo t        ; By default while in insert all changes are one big blob. Be more granular
      auto-save-default t          ; Nobody likes to loose work, I certainly don't
      truncate-string-ellipsis "…" ; Unicode ellispis are nicer than "...", and also save /precious/ space
      password-cache-expiry nil    ; I can trust my computers ... can't I?
      scroll-margin 2)             ; It's nice to maintain a little margin

;; proxy
(setq url-proxy-services
  '(("http"  . "127.0.0.1:51837")
    ("https" . "127.0.0.1:51837")))

(set-language-environment "UTF-8")

;; Font stuff
(setq doom-font (font-spec :family "Source Code Pro" :size 20)
      doom-variable-pitch-font (font-spec :family "Source Code Pro" :size 20)
      doom-unicode-font (font-spec :family "LXGW Wenkai" :size 18))

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-nord)

;; make search elegant
(use-package! ivy
  :bind (("C-s" . swiper)))

;; I prefer counsel to switch buffer
(map! :leader
      :desc "Switch Buffer"
      "SPC" #'counsel-switch-buffer)

;; Stop creating backup~ files
(setq make-backup-files nil)

;; Stop creating #autosave# files
(setq auto-save-default nil)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

(after! org
  (setq org-superstar-headline-bullets-list '("◉" "○" "●" "○" "●" "○" "●")))

(if (not (display-graphic-p))
    (progn
      ;; 增大垃圾回收的阈值，提高整体性能（内存换效率）
      (setq gc-cons-threshold (* 8192 8192 1000))
      ;; 增大同LSP服务器交互时的读取文件的大小
      (setq read-process-output-max (* 1024 1024 256)) ;; 128MB
      ))

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(defadvice! prompt-for-buffer (&rest _)
  :after '(evil-window-split evil-window-vsplit)
  (consult-buffer))

(map! :map evil-window-map
      ;; Navigation
      "C-<left>" #'+evil/window-move-left
      "C-<down>" #'+evil/window-move-down
      "C-<up>" #'+evil/window-move-up
      "C-<right>" #'+evil/window-move-right
      )

(map! :map evil-motion-state-map
      "j" #'evil-next-visual-line
      "k" #'evil-previous-visual-line)

(defun civi/move-line-up ()
  (interactive)
  (transpose-lines 1)
  (forward-line -2))

(defun civi/move-line-down ()
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1))

(map! :map (global-map evil-org-mode-map)
      :ivn "M-<down>" #'civi/move-line-down
      :ivn "M-<up>" #'civi/move-line-up
      :ivn "M-j" #'civi/move-line-down
      :ivn "M-k" #'civi/move-line-up
      )

(map! :map org-mode-map
      "C-j" #'evil-window-down)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)


(map! :map global-map
      :n "U" #'evil-redo
      :g "C-n" #'+treemacs/toggle
      )

;; Automatically tangle our config.org config file when we save it
(defun org-babel-tangle-config ()
  (when (string-equal (buffer-file-name)
                      (expand-file-name "~/.doom.d/config.org"))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook
          (lambda () (add-hook 'after-save-hook #'org-babel-tangle-config :append :local)))
