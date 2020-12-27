(use-modules (gnu)
             (gnu system nss)
             (suckless-patched)
             (nongnu packages linux)
             (nongnu packages mozilla)
             (gnu packages m4)
             (nongnu system linux-initrd)
             (guix channels)
             (guix inferior)
             (srfi srfi-1) ;; (first) for inferior
             (guix utils) ;; For substitute keyword arguments
             (guix packages)
             (guix download)
             (guix licenses) ;; For solarc theme, put in channel and delete TODO
             (guix build-system copy))
(use-service-modules desktop audio sound ssh docker virtualization)
;;(use-package-modules fonts certs suckless wm gl xorg shells linux mpd fontutils pulseaudio)
(use-package-modules shells certs)


;; Versions for pinned channels and packages
(define nonguix-commit "6ae7f62be8ca9d25775e36ec0f43e6a58ece5e7e")
(define guix-commit "06de9ca75f4bb508cdba3082d8ae80f014dbc38b")
(define firefox-ver "84.0.1")
(define linux-ver "5.10.2")

;; Helper functions to prevent unwanted compilations of heavy packages
(define pinned-inferior
  (let*
    ((channels
       (list (channel
               (name 'nonguix)
               (url "https://gitlab.com/nonguix/nonguix")
               (commit nonguix-commit))
             (channel
               (name 'guix)
               (url "https://git.savannah.gnu.org/git/guix.git")
               (commit guix-commit)))))
    (inferior-for-channels channels)))

(define (pinned package version)
  (first (lookup-inferior-packages
           pinned-inferior
           package
           version)))

(define solarc-theme
  (package
    (name "solarc-theme")
    (version "2.0.0")
    (source
      (origin
        (method url-fetch)
        (uri (string-append "https://github.com/schemar/solarc-theme/releases/download/v" version "/solarc-theme-solid-v" version ".tar.xz"))
        (sha256
          (base32
            "105q7rkyjq47qmcygvd0r6c5gcdmccqiamf3q83lrdvcy256gpgd"))))
    (build-system copy-build-system)
    (arguments '(#:install-plan '(("." "share/themes"))))
    (synopsis "Solarized Dark patch for arc-theme")
    (description
      "Solarized Dark patch for arc-theme")
    (home-page "https://github.com/schemar/solarc-theme")
    (license gpl3+)))

(operating-system
  (kernel (pinned "linux" linux-ver))
  (initrd microcode-initrd)
  (firmware (list linux-firmware))

  (host-name "LambdaStation")
  (timezone "America/New_York")
  (locale "en_US.utf8")

  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (target "/boot/efi")))

  (file-systems (append
                  (list (file-system
                          (device (file-system-label "root"))
                          (mount-point "/")
                          (type "ext4"))
                        (file-system
                          (device (uuid "2A64-51C0" 'fat))
                          (mount-point "/boot/efi")
                          (type "vfat"))
                        ;;(file-system
                        ;;(device "/dev/sdc1")
                        ;;(mount-point "/data")
                        ;;(type "ntfs")
                        ;;(check? #f)
                        ;;(options "fmask=0022,dmask=0000"))
                        (file-system
                          (device "/dev/sdd1")
                          (mount-point "/data2")
                          (type "ext4")))
                  %base-file-systems))
  (swap-devices '("/swapfile"))
  ;; This is where user accounts are specified.  The "root"
  ;; account is implicit, and is initially created with the
  ;; empty password.
  (users
    (cons*
      (user-account
        (name "clone")
        (group "users")
        (shell #~(string-append #$zsh "/bin/zsh"))

        ;; Adding the account to the "wheel" group
        ;; makes it a sudoer.  Adding it to "audio"
        ;; and "video" allows the user to play sound
        ;; and access the webcam.
        ;; Adding the netdev group does something
        (supplementary-groups '("wheel" "netdev" "audio" "video" "libvirt"))
        (home-directory "/home/clone"))
      %base-user-accounts))

  ;; Globally-installed packages.
  ;; (list pulseaudio ntfs-3g mpd-mpc mpd fontconfig font-fira-code dwm-clone dmenu st-clone zsh polybar-dwm mesa nss-certs)
  (packages (append
              ;; Non (gnu package)s
              (list nss-certs dwm-clone st-clone polybar-dwm solarc-theme (pinned "firefox" firefox-ver))
              (map specification->package
                   '(
                     ;; System Packages
                     "ntfs-3g"
                     "mesa"

                     ;; Sound
                     "pulseaudio"
                     "mpd"
                     "mpd-mpc"
                     "mpdscribble"
                     "alsa-utils"
                     "pavucontrol"
                     "pulsemixer"

                     ;; DE Packages
                     "arc-theme"
                     "dmenu"
                     "picom"
                     "wmctrl"

                     ;; Fonts
                     "fontconfig"
                     "font-fira-code"
                     "font-dejavu"

                     ;; Shell Tools
                     "zsh"
                     "openssh"
                     "curl"
                     "wget"
                     "tmux"
                     "git"
                     "xclip"
                     "feh"
                     "neofetch"
                     "strace"
                     "zip"
                     "unzip"
                     "lm-sensors"
                     "flameshot"
                     "sysstat"
                     "zip"
                     "scrot"
                     "vim"
                     "ncurses"  ;; For clear command

                     "syncthing"
                     "syncthing-gtk"

                     "docker"
                     "docker-compose"))
              %base-packages))

  (services (cons*
              (service gnome-desktop-service-type)
              (service docker-service-type)
              (service openssh-service-type
                       (openssh-configuration
                         (password-authentication? #f)))
              (service libvirt-service-type
                       (libvirt-configuration
                         (unix-sock-group "libvirt")
                         (tls-port "16555")))
              (service virtlog-service-type
                       (virtlog-configuration
                         (max-clients 1000)))
              ;; TODO: Why isn't mpd service working?
              (service mpd-service-type
                       (mpd-configuration
                         (user "clone")
                         (music-dir "/data/Music")
                         (outputs
                           (list
                             (mpd-output)
                             (mpd-output
                               (type "fifo")
                               (name "visualizer")
                               (extra-options `((path . "/tmp/mpd.fifo")
                                                (format . "44100:16:2"))))))))
              %desktop-services))

  (name-service-switch %mdns-host-lookup-nss))

;; Pulse/Mpd Fucking
;; (outputs (list
;;           (mpd-output
;;            (extra-options `((server . "127.0.0.1"))))))
;; (modify-services %desktop-services
;;                  (pulseaudio-service-type config =>
;;                                           (pulseaudio-configuration
;;                                            (inherit config)
;;                                            (script-file (local-file "/home/clone/.config/pulse/default.pa")))))
;; (user-account
;;  (name "mpd")
;;  (group "users")
;;  (supplementary-groups '("audio" "video"))
;;  (home-directory "/home/mpd"))
;; (groups
;;  (cons*
;;   (user-group
;;    (name "mpd"))
;;   %base-groups))
