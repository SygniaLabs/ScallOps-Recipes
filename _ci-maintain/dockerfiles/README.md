# Container-Builder

Each Dockerfile here is a source to create container images for job or group of jobs within the Offensive Pipeline.
Keep the name convention: \<IMAGE-NAME\>.dockerfile and the related directory structure to make sure that the script will identify your dockerfile, build  and push it to your project's container registry (gcr.io). Note that we are updating the tag name with "latest" on every push.

> This means that you will be able to push \<file-name\>.dockerfile under dockerfiles/linux/ , directly from code to your container registry after committing the dockerfile code to master!

## Limitations

Currently, only linux based Dockerfiles can be built on top of another container ([Learn more](https://github.com/GoogleContainerTools/kaniko)). As a workaround for Windows based images, you may build and push container images manually, or use public ones avaialble at Docker hub and other registries - [see issues](https://github.com/SygniaLabs/ScallOps#open-issues).
You can find more information about pushing and pulling from GCR [here](https://cloud.google.com/container-registry/docs/pushing-and-pulling)

Due to current GKE (Google Kubernetes Engine) available Windows versions, container images required to be based on Windows 1809:
mcr.microsoft.com/windows/servercore:1809 or Windows equivalent server-core with 1809, for example: golang:windowsservercore-1809


## Security consideration
Due to permissions required by the GCP Container Registry, the Terraform deployment created a service account with **storage.admin** permissions to a specific bucket that stores the container images. This allows the Kaniko runner to authenticate and push container images directly to your registry. Kaniko runner is registered as a specific runner to the Scallops-Recipes repository, and executes only on protected branches. Thus, only Maintainers (and above) of the Scallops-Recipes repository will be able to operate it and access the service account's key.

> TIP: Use clean GCP project for the whole deployment in order to refrain from risk to other resources on your cloud.

## Optimization

Try to enhance existing Dockers for different techniques instead of creating new ones.
On each docker file, use comments to include the command that should be executed in order to guide on how to develop the job recipes.
Feel free to choose any linux related base image, but if you don't have any special needs, stick to the images below in order to save disk space and network bandwith:
  * ubuntu:bionic
  * ruby:\<version\>alpine

