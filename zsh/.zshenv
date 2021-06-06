# -*- sh -*-
source "$HOME/.cargo/env"
if [ -e /home/clone/.nix-profile/etc/profile.d/nix.sh ]; then . /home/clone/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

#
# GNU Guix
#
#Locales
export GUIX_LOCPATH="$HOME/.guix-profile/lib/locale"
export LC_ALL=en_US.utf8
export LANG=en_US.utf8

#Certs
export SSL_CERT_DIR="$HOME/.guix-profile/etc/ssl/certs"
export SSL_CERT_FILE="$HOME/.guix-profile/etc/ssl/certs/ca-certificates.crt"
export GIT_SSL_CAINFO="$SSL_CERT_FILE"

export GUIX_PACKAGE_PATH="$HOME/guix-packages:$HOME/guix-packages/gems"

. "$HOME/.config/guix/current/etc/profile"

GUIX_PROFILE="/home/clone/.guix-profile"
. "$GUIX_PROFILE/etc/profile"


export guix_extra_profiles=(de emacs emacs-doom)

GUIX_EXTRA_PROFILES=$HOME/.guix-extra-profiles
for i in $GUIX_EXTRA_PROFILES/*; do
  profile=$i/$(basename "$i")
  if [ -f "$profile"/etc/profile ]; then
    GUIX_PROFILE="$profile"
    . "$GUIX_PROFILE"/etc/profile
  fi
  unset profile
done

export EMAIL="noah@nevans.me"
