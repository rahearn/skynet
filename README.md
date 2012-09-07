Skynet
======

GitHub-aware website builder

Skynet builds and deploys web sites on your VPS or bare metal server. It is triggered by the post-receive hook.

Current Builder Types
---------------------

1. Static. Copies the entire repository to the specified destination and then
   removes the destination .git folder
1. Jekyll. Run jekyll on your repository. Entirely controlled by
   site's `_config.yml`

Usage
-----

* Install Skynet: `$ gem install skynet-deploy`
* Install basic config file: `$ skynet config <first project name>`
* edit config file to add your repositories
* Run builder by hand to ensure everything works: `$ skynet build`
* Add `http://YOUR_SKYNET_SERVER/PROJECT_NAME` as a WebHook URL to your repository under `Admin -> Service Hooks`
* Start server: `$ skynet server`

Example Post-Receive Hook
-------------------------

Add this to your `.git/hooks/post-receive` file to use Skynet with
a git server other than GitHub.

    read oldrev newrev refname

    curl -d "payload={\"repository\":{\"url\":\"<<same path as in config.yml>>\"},\"before\":\"$oldrev\",\"after\":\"$newrev\",\"ref\":\"$refname\"}" http://YOUR_SKYNET_SERVER/PROJECT_NAME

The URL must be visible from the Skynet server, as it will pull a new
copy of the repository from this server.
