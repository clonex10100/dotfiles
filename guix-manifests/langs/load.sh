#!/bin/sh
manifests=""
for manifest in ~/langs/*.scm; do
	manifests="${manifests} -m ${manifest}"
done
guix package -c 3$manifests -p ~/.guix-extra-profiles/langs/langs
