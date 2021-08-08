# Container-Builder

Each Dockerfile here is a source to create container images for job or group of jobs within the Offensive Pipeline.
Keep the name convention: \<IMAGE-NAME\>.dockerfile and the related directory structure to make sure that the script will identify your dockerfile, build  and push it to your project's container registry (gcr.io). Note that we are updating the tag name with "latest" on every push.

> This means that you will be able to push \<file-name\>.dockerfile under dockerfiles/linux/ , directly from code to your container registry after committing the dockerfile code to master!

## Limitations

Currently, only linux based Dockerfiles can be built on top of another container ([Learn more](https://github.com/GoogleContainerTools/kaniko)). As a workaround for Windows based images, you may build and push container images manually, or use public ones avaialble at Docker hub and other registries. Keep in mind that windows related container image must include built-in powershell core - [see issues](https://github.com/SygniaLabs/ScallOps#open-issues)
You can find more information about pushing and pulling from GCR [here](https://cloud.google.com/container-registry/docs/pushing-and-pulling)

Due to current GKE (Google Kubernetes Engine) available Windows versions, container images required to be based on Windows 1809:
mcr.microsoft.com/windows/servercore:1809 or Windows equivalent server-core with 1809, for example: golang:windowsservercore-1809


## Security consideration
Due to permissions required by the GCP Container Registry, the Terraform deployment, created a service account with **storage.admin** permissions, so Linux Pods will be able to authenticate and push container images to the registry.
The authentication token is mapped through the K8s secret, and avaialable to any Linux Pod to read.
It means that anyone with acces to execute CI jobs with this runner, will be able to read/write/destroy all your storage buckets and related storage objects in the deployed GCP project.
If you prefer to mitigate this risk and waive the container push feature, you may browse to your GCP console, navigte to IAM & Admin -> Service Accounts -> Disable a service account with the convention: **\<INFRA-NAME\>-gke-buckt@<PROJECT_ID>.iam.gserviceaccount.com**.
Note, that pulling images from your GCP project's registry by the K8s hosting nodes, won't be affected.

> TIP: Use clean GCP project for the whole deployment in order to refrain from this risk.

## Optimization

Try to enhance existing Dockers for different techniques instead of creating new ones.
On each docker file, use comments to include the command that should be executed in order to guide how to develop the job recipes.
Feel free to choose any linux related base image, but if you don't have any special needs, stick to the image below in order to save disk space and network bandwith:
ubuntu:bionic

