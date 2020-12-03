#!/bin/sh
manifests=""
for manifest in ~/langs/*.scm; do
	manifests="${manifests} -m ${manifest}"
done
guix package$manifests -p ~/.guix-extra-profiles/langs/langs
