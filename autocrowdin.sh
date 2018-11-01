#!/bin/sh

set -o nounset
set -o errexit

update() {
	git checkout "$1"
	java -jar /opt/crowdin/crowdin-cli.jar --config .crowdin.yaml download -b "$2"
	git clean -f
	if git commit -a -m "Automatically update translation keys ($1)"; then
		git push origin "$1"
	fi
	git clean -fdx
}

# Ensure keys are being removed at the end
cleanup() {
	rm -f ~/.crowdin.yaml ~/.ssh/id_rsa
}
trap cleanup EXIT

# Prepare crowdin configuration
echo "api_key: ${CROWDIN_API_KEY}" > ~/.crowdin.yaml

# Prepare Github SSH key
echo "${GITHUB_DEPLOY_KEY}" > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa
ssh-keyscan github.com >> ~/.ssh/known_hosts

# Log commands (do not log keys above)
set -o xtrace

# clone repository
git clone git@github.com:opencast/opencast.git
cd opencast
git config  user.email 'crowdin-bot@opencast.org'
git config user.name 'Crowdin Bot'

# Update develop and latest two release branches
update develop develop
for branch in $(git branch -r | sed -n 's_.* origin/r/__p' | tail -n 2); do
	update "r/$branch" "$branch"
done
