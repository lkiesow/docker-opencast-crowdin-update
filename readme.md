Container to Update Opencast's Tranlations
==========================================

Docker container to automatically retrieve translation updates from Crowdin and
push them to the official repository.

```bash
$ docker run \
  -e CROWDIN_API_KEY=123 \
  -e GITHUB_DEPLOY_KEY=234 \
  quay.io/lkiesow/opencast-crowdin-update
```
