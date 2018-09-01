#!/bin/sh

set -eux

update() {
	git checkout "$1"
	java -jar /opt/crowdin/crowdin-cli.jar --config .crowdin.yaml download -b "$2"
	git clean -f
	git config  user.email 'crowdin-bot@opencast.org'
	git config user.name 'Crowdin Bot'
	git commit -a -m 'Automatically update translation keys'
	echo git push origin "$1"
	git clean -fdx
}

# Prepare crowdin configuration
echo "api_key: ${CROWDIN_API_KEY}" > ~/.crowdin.yaml

# Prepare Github SSH key
echo "${GITHUB_DEPLOY_KEY}" > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa
ssh-keyscan github.com >> ~/.ssh/known_hosts

# clone repository
git clone git@github.com:opencast/opencast.git
cd opencast

update develop develop
for branch in $(git branch -r | sed -n 's_.* origin/r/__p' | tail -n 2); do
	update "r/$branch" "$branch"
done
