[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![Gitlab](https://img.shields.io/badge/Gitlab-v13.10+-cb4e18.svg?style=plastic)
![ScallOps](https://img.shields.io/badge/ScallOps-v0.1-000000.svg?style=plastic)

# ScallOps-Recipes

## Overview

This repository is part of the [ScallOps](https://github.com/SygniaLabs/ScallOps) framework. It has to be imported into the framework that is operated on top of a Gitlab server and the related infrastructure on GCP. It can work with other Gitlab (13.10 and above) instances as well, but require several customizations.

> The ScallOps Terraform deployment automatically imports this repository into your Gitlab instance.

<p align="center">
  <img src="./img/scallops.png" alt="ScallOps logo" width="" height="300">
</p>


All offensive pipeline automation logics are stored in this repository. Each file here acts as a module which can get referenced as part of a pipeline recipe. It works by referencing a single file of CI/CD settings to each repository, which then compose the related pipeline using the available modules. 
You can always develop additional modules and extend your offensive tools weaponization techniques.


## Features
Can be used by triggering ScallOps-Recipes repository.
- Tools import - An automated pipeline that imports external repositories into your Gitlab ([See security considerations](https://github.com/SygniaLabs/ScallOps#security-considerations)).
- Container Builder - A pipeline that build and push container image from Dockerfile, directly into your container registry ([See security considerations](https://github.com/SygniaLabs/ScallOps#security-considerations)).
- Multi pipeline trigger - An example of method to invoke multiple repositories pipelines from one place.

Tool weaponization currently supports:
- C# compiling
- GO compiling
- GO compiler and obfuscator
- ConfuseEX obfuscation
- Chimera Obfuscation
- PwnDrop deployer

Tool collection:
- [Rubeus](https://github.com/GhostPack/Rubeus.git) 
- [SharpHound3](https://github.com/BloodHoundAD/SharpHound3.git) 
- [Seatbelt](https://github.com/GhostPack/Seatbelt.git) 
- [SharpDPAPI](https://github.com/GhostPack/SharpDPAPI.git) 
- [SharpWMI](https://github.com/GhostPack/SharpWMI.git) 
- [PowerUp](https://github.com/HarmJ0y/PowerUp.git) 
- [Inveigh](https://github.com/Kevin-Robertson/Inveigh.git) 
- [pingcastle](https://github.com/vletoux/pingcastle.git) 
- [DomainPasswordSpray](https://github.com/dafthack/DomainPasswordSpray.git) 
- [PrintNightmare](https://github.com/cube0x0/CVE-2021-1675.git) 
- [PowerUpSQL](https://github.com/NetSPI/PowerUpSQL.git) 
- [goddi](https://github.com/NetSPI/goddi.git) 
- [gowitness](https://github.com/sensepost/gowitness.git) 
- [SharpEDRChecker](https://github.com/PwnDexter/SharpEDRChecker.git) 


## Structure

The below is a suggested structure to design your jobs and recipes when using the ScallOps framework:
```text
-> ScallOps-Recipes
    -> _ci-maintain              // The core of the framework. It contain healthchecks, tools importer 
                                    and a container builder.
        -> ci-container-builders // Containning jobs that build and push your container from Dockerfile 
                                    code.
        -> dockerfiles           // Your actual containers as Dockerfiles to use during various types of 
                                    pipelines.
    -> ci-builders               // Containning jobs that build tools from source.
    -> ci-deployers              // Containning jobs that deploy artifacts to different types of  
                                    hostings.
    -> ci-obfuscations           // Containning jobs that obfuscate source codes and/or compiled binaries.
    -> ci-multi-pipeline         // Containning jobs that tags different tools, making it easier to 
                                    weaponize them in groups.
    -> ci-tools-controllers      // Any tool that you wish to weaponize must have a YAML file here. This 
                                    is where we choose the relevant pipeline we want ot apply on a 
                                    single tool.
        -> .tools-index.json     // Tools repository index, it will automatically import new tools from 
                                    their public  Git source. Great way to manage the tools you are 
                                    using as a code.
    -> .gitlab-ci.yml            // The master pipeline. Manages the deployment and the instance using 
                                    special jobs. Used for multi pipeline triggering as well.
``` 


## Flow

1. Import the tool.
2. Design the tool's CI/CD recipe (YAML format), Reference coded recipes to build/obfuscate/deploy/etc.
3. Optional - Code additional recipes to reference for additional needs.
4. Optional - Code, build and push relevant job recipe Dockerfile - [See Container-Builder](https://github.com/SygniaLabs/ScallOps-Recipes/tree/main/_ci-maintain/dockerfiles/README.md).
5. Optional - Add pipeline trigger conditions to use when triggering a multi-pipeline.

The above can be done in **one** commit to the master branch of ScallOps-Recipes.

6. Trigger a Pipeline!

See next section for more details about every step in the flow.


## Designing Recipes

First, I encourage you to go over the Gitlab official CI/CD documentation to get familiar with their CI/CD and pipeline concepts https://docs.gitlab.com/ee/ci/.

Then, you can go over the examples below to better understand how we design an Offensive Pipeline while "frameworking" the whole process.

At this section, we will extend and explain each stage that was described in the flow.

1. Any new tool that you will import, has to point at it's relevant YAML instructor at ci-tools-controllers/\<tool-name\>.yaml which will instruct it to follow other relevant YAML containning jobs to be added to the YAML.

**.tools-index.json - Import Example**
- name - The name of the tool will be reflected at your Gitlab instance (unique).
- import_url - Public Git url to import the tool from.
- visibility - Can be either public (Anyone with network access to the Gitlab instance), internal (Any registered user) or private (Access allowed to the importing user - this case: root).
- ci_config_path - The path to the YAML where the tool get its CI/CD pipeline configuration.

```json
    {
        "name": "Rubeus",
        "import_url":"https://github.com/GhostPack/Rubeus.git", 
        "visibility":"internal", 
        "ci_config_path": "ci-tools-controllers/Rubeus-ci.yml@root/scallops-recipes"
    }

```

2. **Rubeus-ci.yml - Tool CI/CD pipeline controller example**

- variables - Unique variables related to the tool that needed to be referenced from different stages during pipeline.
- include - Additional Recipes (YAML format jobs) that we want to include within our pipeline related to this tool.
- stages - The order of the stages we wish our tool to pass through.

```yaml
variables:
  EXE_RELEASE_FOLDER: 'Rubeus/bin/Release'
  EXE_FILE_NAME: 'Rubeus.exe'
  CI_PROJECT_SLN_PATH: 'Rubeus.sln'


include:
  - project: 'root/scallops-recipes'
    file: 'ci-builders/sharptools-ci.yml'
  - project: 'root/scallops-recipes'
    file: ci-obfuscations/confuserEX-windows.yml
  - project: 'root/scallops-recipes'
    file: ci-deployers/pwndrop-ci.yml

stages:
  - build
  - obfuscate
  - deploy

```

3. **chimera-ps-obfuscation-ci.yml - Tool CI/CD pipeline controller example**

- variables - Setting additonal variables we want to use during this job or the following jobs/stages (On the same pipeline).
- ps_chimera_obfuscation - The name of the job.
- stage - The stage we assign when referencing this job.
- image - On which container image this job has to be executed.
- tags - These tags help the pipeline to locate the relevant CI runner to execute the job on.
- script - The commands that apply the relevant changes to the source/binary. In this case, obfuscation.
- artifacts - The path/s for the files output we wish to keep as part of this job result.

```yaml

variables:
  PS_OBFUSCATED_FILE_NAME: $PS_FILE_NAME-chimered.ps1
  DEPLOY_FILE_PATH: $PS_FILE_NAME-chimered.ps1
ps_chimera_obfuscation:
  stage: obfuscate
  image: ubuntu:18.04
  tags: 
   - kubernetes
   - linux
  script:
   - echo $PS_FILE_NAME
   - ls -la
   - printenv
   - apt-get update && apt-get install -Vy sed xxd libc-bin curl jq perl gawk grep coreutils git
   - git clone https://github.com/tokyoneon/chimera
   - chmod +x chimera/chimera.sh; chimera/chimera.sh --help
   - 'chimera/chimera.sh -f $PS_FILE_NAME -k -s -j -b -l 0 -r -o $PS_OBFUSCATED_FILE_NAME'
  artifacts:
    paths: 
      - $PS_OBFUSCATED_FILE_NAME
    expire_in: 1 week
```


4. **chimera.dockerfile - An Example of a Dockerfile under dockerfiles/linux**

This Dockerfile, after comitted to master branch, can get built and pushed to the container registry, it can get referenced through different jobs' "image" key.
See [Container-Builder](https://github.com/SygniaLabs/ScallOps-Recipes/tree/main/_ci-maintain/dockerfiles) README to learn the considerations when designning a Dockerfile for the framework.

```dockerfile
FROM ubuntu:18.04
  
RUN apt-get update && apt-get install -y \
    sed \
    xxd \
    libc-bin \
    curl \
    jq \
    perl \
    gawk \
    grep \
    coreutils \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/tokyoneon/chimera /opt/chimera
RUN chown root:root -R /opt/chimera
WORKDIR /opt/chimera
RUN chmod +x chimera.sh
```

5. **ad.yml - An Example of a job that trigger another repository pipeline**

The job triggers the other pipeline based on different conditions supplied from the $CI_MULTI_TRIGGER variable. You can reach it by triggering the ScallOps-Recipes repository and insert a value to the pre-filled variable.

```yaml
trigger_Rubeus:
  stage: multiTrigger
  only:
    variables:
     - $CI_MULTI_TRIGGER == "kerberos"
     - $CI_MULTI_TRIGGER == "ad"
     - $CI_MULTI_TRIGGER == "windows"
     - $CI_MULTI_TRIGGER == "all"
  trigger: 
    project: root/Rubeus
  variables:
    PWNDROP_WRITE_KEY: $PWNDROP_WRITE_KEY
    PWNDROP_URL: $PWNDROP_URL
```

## Trigger a Pipeline 

After importing your favorite offensive tools, designing multiple modules that are derived from great offensive techniques, and building customized pipeline recipes for every tool, it is the time to weaponize your toolbox.

Let the automation begin! 
It is the time to behold the magic of coded offensive techniques!

If you are struggeling with triggering a pipeline, you can learn how to manually/automatically trigger it for a single repository or group of repositories:

1. **Web UI** - Browse to the repository -> CI/CD -> Pipelines -> Run pipeline -> Optional: specify variables -> Run pipeline
2. **[API / Webhook](https://docs.gitlab.com/ee/ci/triggers/)**
3. **Multi trigger** - Trigger pipeline of ScallOps-Recipes repository, and provide relevant value to the "CI_MULTI_TRIGGER" variable.


## Contribution

This project is developed and maintained by Sygnia's Adversarial Research team.
Your contributions is more than welcome!

The whole framework started off with the main idea to enable security researchers to express their offensive techniques as a code. Coded techniques then can aid in creating modules, that are referenced during the process of weaponizing offensive tools. Security teams will be able to upgrade their toolbox faster and save tremendous amount of time in the preparation for adversary simulation engagements.

Contributions can be made in code, as well as in ideas you might have for further development, issues, optimizations, risks, usability, improvements, etc.