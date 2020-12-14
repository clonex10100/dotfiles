;; -*- geiser-scheme-implementation: guile -*-
(specifications->manifest
 '("emacs"
   "emacs-doom-themes"
   "emacs-counsel" ;; Contains ivy
   "emacs-ivy-rich"
   
   "emacs-which-key"
   
   "emacs-neotree"
   
   ;;"emacs-doom-modeline"
   "emacs-powerline"
   "emacs-airline-themes" ;; Not in guix yet
   
   "emacs-rainbow-delimiters"
   "emacs-general"
   
   "emacs-vterm"
   ;; Vterm deps
   "cmake"
   "make"
   "libvterm"
   
   "emacs-smartparens"
   "emacs-helpful"
   "emacs-guix" ;; Curently broken
   "emacs-org"
   "emacs-org-journal"
   "emacs-org-roam"
   "emacs-company"
   
   "emacs-flycheck"
   "emacs-flycheck-guile"
   
   
   "emacs-yasnippet"
   "emacs-yasnippet-snippets"
   "emacs-ivy-yasnippet"
   
   "emacs-projectile"
   
   "emacs-lsp-mode"
   "emacs-lsp-ui"
   "emacs-lsp-ivy"
   "emacs-eros"
   "emacs-geiser"
   "mit-scheme"
   "python-language-server"
   "emacs-rust-mode"
   "emacs-flycheck-rust"
   "shellcheck"
   "emacs-evil"
   "emacs-evil-org"
   "emacs-evil-smartparens"
   "emacs-evil-collection"
   "emacs-evil-surround"
   "emacs-evil-leader"
   "emacs-evil-escape"
   "emacs-pdf-tools"))
