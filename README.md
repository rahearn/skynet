Skynet
======

[![Build Status](https://travis-ci.com/rahearn/skynet.svg?branch=master)](https://travis-ci.com/rahearn/skynet)

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
* Add `http://YOUR_SKYNET_SERVER/PROJECT_NAME` as a Webhook Payload URL to your repository under
 `Settings -> Webhooks & Services`. Choose `application/vnd.github.v3+form` as the Payload version.
* Start server: `$ skynet server`

Config file arguments
---------------------

### Required configuration variables for each project: ###
* `url` Value passed from post-receive hook to verify that the deploy
  should happen
* `type` The builder type to invoke for this application
* Either `branch` and `destination` together or only `branches` must be specified

### Optional configuration variables: ###
* `key` SSH private key file to be used to clone and pull from private
  repositories. Should be given as an absolute path
* `repository` The location to clone the repository from. This is
  usually inferred from `url`, but can be overridden here
* `branch` The branch to be deployed
* `destination` Absolute path to the deployed application
* `branches` For when multiple branches should be deployed to this
  machine (such as a production + staging strategy). `branches` is a
  hash with keys being the branch name and values being the destination

Example Post-Receive Hook
-------------------------

Add this to your `.git/hooks/post-receive` file to use Skynet with
a git server other than GitHub.

    read oldrev newrev refname

    curl -d "payload={\"repository\":{\"url\":\"<<same path as in config.yml>>\"},\"before\":\"$oldrev\",\"after\":\"$newrev\",\"ref\":\"$refname\"}" http://YOUR_SKYNET_SERVER/PROJECT_NAME

The URL must be visible from the Skynet server, as it will pull a new
copy of the repository from this server.
