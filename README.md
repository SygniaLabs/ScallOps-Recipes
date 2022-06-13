[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=plastic)](https://opensource.org/licenses/MIT)
![Gitlab](https://img.shields.io/badge/Gitlab-v14.9.3-cb4e18.svg?style=plastic)
![ScallOps](https://img.shields.io/badge/ScallOps-v0.3-000000.svg?style=plastic)

# ScallOps-Recipes

## Overview

This repository is part of the [ScallOps](https://github.com/SygniaLabs/ScallOps) framework. It has to be imported into the framework that is operated on top of a Gitlab server and the related infrastructure on GCP. It can work with another Gitlab (14.5.2 and above) instance as well, but may require several customizations.

> The ScallOps Terraform deployment automatically imports this repository into your Gitlab instance.

<p align="center">
  <img src="./img/scallops.png" alt="ScallOps logo" width="" height="300">
</p>


All offensive pipeline automation logics are stored in this repository. Each file here acts as a module which can get referenced as part of a pipeline recipe. It works by referencing a single file of CI/CD settings to each repository, which then compose the related pipeline using the available modules. 
You can always develop additional modules and extend your offensive tools weaponization techniques.


## Features
All weaponization and maintenance pipelines can be triggered using ScallOps-Recipes repository.

- Single control pane - Invoke multiple pipelines from one page or specific API endpoint.

### Tool inventory

- See our [tools index](ci-tools-controllers/.tools-index.json) 
- You can provide remote hosted binaries or scripts from the following formats: PE, dotNET, PS, Shellcode
- You can also provide remote C# or C++ repositories.

### Weaponization methods and modules (a.k.a Recipes)

Pre-Build obfuscations - [ci-preobfuscate](ci-preobfuscate)
- Powershell obfuscation (Commnets,Variables,Backticks) - powered by [Chimera](https://github.com/tokyoneon/Chimera)
- C# source code obfuscation (Modification of Names & GUID, removal of PDBs and comments, and strings obfuscation) - powered by [InvisibilityCloak](https://github.com/h4wkst3r/InvisibilityCloak)

Compilers - [ci-builders](ci-builders)
- C# compilation
- CSC Builder
- GO compiling
- C++ 
- C++ with WDK

Post-Build Binary obfuscation - [ci-obfuscations](ci-obfuscations)
- dotNET obfuscations (Protections: constants,ctrlflow,refproxy,rename,resources,typescramble) - powered by [ConfuseEX](https://github.com/mkaring/ConfuserEx) 

Binary Converters [ci-converters](ci-converters)
- PE to shellcode converter - powered by [donut](https://github.com/TheWover/donut)

Encryptors / Encoders - [ci-encrypters](ci-encrypters)
- dotNET Base64 + Xor
- Powershell AES encryption - powered by [PowerShellArmoury](https://github.com/cfalta/PowerShellArmoury)
- Embed & encrypt C# into Powershell - powered by [PowerShellArmoury](https://github.com/cfalta/PowerShellArmoury)
- Shellcode encryption - powered by [DInjector](https://github.com/snovvcrash/DInjector/blob/main/encrypt.py)

 Evasions - [ci-evasions](ci-evasions)
- AMSI-bypass - powered by [AMSI.fail](https://amsi.fail)
- PSReadline

 Loaders - [ci-loaders](ci-loaders)
- Load AMSI-bypass in chunks
- Base64 + Xor dotNET reflective loader
- DLL shellcode loader (with fake signatures) - powered by [ScareCrow](https://github.com/optiv/ScareCrow)

Executors - [ci-executors](ci-executors)
- Loaded dotNET Assembly invoker (Powershell based)
- Encrypted Shellcode injection - powered by [DInjector](https://github.com/snovvcrash/DInjector)

Tests - [ci-tests](ci-tests)
- Windows 10 EXE execution
- Windows 10 Powershell invoker

Anti-Virus Tests - [ci-avtests](ci-avtests)
- Defendercheck - provides HEX of the detected malicous part - powered by [ThreatCheck](https://github.com/rasta-mouse/ThreatCheck), See pre-requisites

Output Deployers - [ci-deployers](ci-deployers)
- Send artifacts to [Pwndrop](https://github.com/kgretzky/pwndrop), See [pull-request](https://github.com/kgretzky/pwndrop/pull/28) for supported version.


### Maintenance - [_ci-maintain](_ci-maintain)
- Tools import - An automated pipeline that imports external repositories into your Gitlab (See pre-requisites)
- Container Builder - A pipeline that builds and pushes Linux container image from Dockerfile, directly into your container registry ([See architecture](https://github.com/SygniaLabs/ScallOps#architecture)).
- Health check - Tests the functinal level and communication of the attached K8s cluster, runners, and validity of required API keys.


## Gitlab Configuration Pre-requisites
For few internal features and modules to function properly, the framework requires the configuration of the following:
  - Gitlab API personal token with **READ* scope (from low privileged account) configured as an [instance level CI/CD variable](https://docs.gitlab.com/ee/ci/variables/#add-a-cicd-variable-to-an-instance). Variable name is: GITLAB_READ_API. This will enable the feature that automatically downloads compiled binaries instead of rebuilding them everytime. Thus, the personal token required permissions are to download artifacts from repositories in "Community" group.
  - For the automated Tools importer feature, it is required to create personal token with permissions to read and write to projects under the Community group. The token must be configured on the Scallops-Recipes [project's CI/CD variables](https://docs.gitlab.com/ee/ci/variables/#add-a-cicd-variable-to-a-project). Don't forget to Mask and Protect it via the same setting.
  - The Defendercheck AV test requires a system where Defender is installed but disabled. Thus, it is required to [install](https://docs.gitlab.com/runner/install/windows.html) Gitlab runner on a suitable system, register it to the instance, and configure it with the 'models,tests' tags.


## Usage

To operate with the framework, we have to setup or provide the **input**, activate the desired **modules**, run the pipeline, and expect for the output. 

> You must run the healthcheck pipeline for freshly deployed environments. Use the HEALTH_CHECK variable with value '1'. Make sure all jobs pass sucessfully.
  
### Trigger a Pipeline 

If you are struggeling with triggering your first pipeline, you can learn how to manually/automatically trigger it using one of the options below:

1. **Web UI** - Browse to the Scallops-Recipes repository in your Gitlab -> CI/CD -> Pipelines -> Run pipeline -> [Specify variables](README.md#variable-reference) -> Click Run pipeline
    * Tip: Direct link to run pipeline - https://\<YOUR-HOSTNAME\>/ci/scallops-recipes/-/pipelines/new
2. **API** - Create pipeline [trigger token](https://docs.gitlab.com/ee/ci/triggers/#create-a-trigger-token) on the Scallops-Recipes repositroy, and trigger it via [API](https://docs.gitlab.com/ee/ci/triggers/#trigger-a-pipeline) while providing required variables.


### Variable Reference

The interaction with the Scallops framework is done using pipelines, and thus require to specify pipeline variables in order to generate the outputs.
There are way too many variables being passed from one job to another job, and another pipeline. This includes OS environmental variables, Runners variables and built-in Gitlab variables.
In this section, I will list and detail only variables related to the Scallops framework that will allow you to use the features mentioned above.

Scallops introduces few variables types:
 - File/Tool Input - Variables to bring file/repository to be processed within the pipeline. File may be of any pipeline family that we support (dotNET, PS, PE, shellcode).
 - Module Activator - Variables that activate techniques to process and weaponize our files/tools. All variables in this type support comma separated values.
 - Module variable - An optional or required variable that comes as a helper to a Module Activator value. Aiding with customization of a single technique during the weaponization.
 - Maintain - Variables that automate tasks related to the framework configuration.


  
**Input variables:**  
  
<details>
<summary>CI_MULTI_TRIGGER</summary>

  * Description: Pick specific tool or group of tools from our inventory based on their names and tags in a comma separated style.  
  * Values: \<See [link](ci-tools-controllers/.tools-index.json)\>  
  * Module Variables:   
    * CI_FORCE_REBUILD  
      * Description: By default, we download the last successful build from our cache. If compilation is still required, you can use this flag.  
      * type: Optional  
      * Values: true  
</details>

<details>
<summary>REMOTE_FILE_URL</summary>

  * Description: Specify URL to download any remote payload you would like to process. Make sure that the K8s nodes IP addresses are whitelisted in your file server.  
  * Values: \<URL\>  
    * Module Variable: REMOTE_FILE_TYPE  
      * Description: Specify the file type that will be downloaded. File name is taken from the end of the link in REMOTE_FILE_URL.   
      * type: **Required**  
      * Values:    
        * dotNET - dot NET assembly File (EXE)
        * shellcode - Any windows compatible shellcode (BIN)
        * PE - Any Executable (EXE)
        * PS - Single file Powershell script (PS1)
</details>

<details>
<summary>REMOTE_REPO_URL</summary>

  * Description: Specify URL to clone remote repository ending with '.git'. See required variables.
  * Values: \<URL\>
  * Dependencies: CI_FORCE_REBUILD=true  
    * Module Variable: REMOTE_REPO_LANG  
      * Description: Specify the SDK language for the clonning repository.  
      * type: **Required**  
      * Values:    
        * cpp
        * csharp
    * Module Variable: EXE_RELEASE_FOLDER  
      * Description: Relative path from repository's root to the binary release folder (Can be found in .csproj/.vcproj files).  
      * type: **Required**  
      * Values: \<PATH\>  
    * Module Variable: EXE_FILE_NAME  
      * Description: Compiled binary file name including extension (Should be similar to the Solution file).  
      * type: **Required**  
      * Values: \<FILENAME\>.exe / .dll  
    * Module Variable: CI_PROJECT_SLN_PATH  
      * Description: Relative path from repository's root to the solution file.  
      * type: **Required**  
      * Values: \<PATH\>\<FILE\>.sln    
    * Module Variable: DOTNET_NAMESPACE  
      * Description: Specify the project's entry namespace (Default: \<Project's name\>).  
      * type: Optional  
      * Values: \<A-z\>   
    * Module Variable: DOTNET_CLASS  
      * Description: Specify the project's entry class under the entry namespace (Default: "Program").  
      * type: Optional  
      * Values: \<A-z\>   
    * Module Variable: DOTNET_ENTRY_METHOD  
      * Description: Specify the project's entry method under the entry class (Default: "Main").  
      * type: Optional  
      * Values: \<A-z\>   
</details>  
<br />  
<br />   

**Module Activator variables:**  
  

<details>
<summary>CI_PREOBFUSCATIONS</summary>

  * Description: Source code Obfuscation techniques to use.  
  * Values:
    * Namings-GUID-PDB (Supported File types: dotNET)
      * Module Variable: OBFUSCATED_PROJECT_NAME
        * Description: New trustful project name for the tool you are weaponizing. Note that this will be the name of the final binary as well.   
        * type: **Required**
        * Values: \<\[A-z\]+\> 
    * psCommnets (Supported File types: PS)
    * psVariables (Supported File types: PS)
    * psBackticks (Supported File types: PS)
</details>

<details>
<summary>CI_OBFUSCATIONS</summary>

  * Description: Post compilation binary obfuscation techniques.  
  * Values:
    * constants (Supported File types: dotNET)
    * ctrlflow (Supported File types: dotNET)
    * refproxy (Supported File types: dotNET)
    * rename (Supported File types: dotNET)
    * resources (Supported File types: dotNET)
    * typescramble (Supported File types: dotNET)
</details>

<details>
<summary>CI_CONVERTERS</summary>

  * Description: File type conversion methods.  
  * Values:
    * PEtoSHELLCODE (Supported File types: PE)
      * Module Variable: SHELLCODE_ARGS
        * Description: Command line arguments for shellcode conversion.
        * type: Optional
        * Values: \<Any\>
</details>

<details>
<summary>CI_ENCRYPTERS</summary>

  * Description: Script and binary encoders / encrypters / packers to use.  
  * Values:
    * b64Xor (Supported File types: dotNET)
    * DInjectorEncrypt (Supported File types: Shellcode)
    * PSEncrypt (Supported File types: PS)
    * CStoPSEncrypt (Supported File types: dotNET)
</details>

<details>
<summary>CI_EVASIONS</summary>

  * Description: Create portable OS and process evasion techniques. Apply process evasions for the payload.  
  * Values:
    * amsiBypass (Input not required)
      * Module Variable: AMSIBYPASS_PAYLOAD_TYPE
      * Description: Choose between 4 different payload types by sepcfiying their number (1-4), 5 is random. Use encoded to Base64 encode the payload (default: '4 plain').  
      * type: Optional
      * Values: \<1-5\> \<plain/encoded\>
    * psReadline (Input not required)
</details>

<details>
<summary>CI_LOADERS</summary>

  * Description: Specify loader techniques to wrap the payload with. Some modules depend on equivalent modules from previous stages.  
  * Values:
    * b64XorRefelection (Supported File types: dotNET)
      * Dependencies: CI_ENCRYPTERS=b64Xor
    * shellcode-dll (Supported File types: Shellcode)
      * Dependencies: REMOTE_FILE_TYPE=shellcode OR CI_CONVERTERS=dotNETtoSHELLCODE
    * amsibypassChunker 
      * Dependencies: CI_EVASIONS=amsiBypass
</details>

<details>
<summary>CI_EXECUTORS</summary>

  * Description: Generate executor to your task with specific methods.  
  * Values:
    * shellcode-injection (Supported File types: Shellcode)
      * Module Variable: SHELLCODE_INJECTION_TECHNIQUE
        * Description: Choose a SINGLE injection technique to be applied to the shellcode-injection executor.   
        * type: Optional
        * Values: 
          * functionpointer
          * functionpointerv2
          * clipboardpointer
          * currentthread ← Default
          * currentthreaduuid
          * remotethread
          * remotethreaddll
          * remotethreadview
          * remotethreadsuspended
          * remotethreadkernelcb
          * remotethreadapc
          * remotethreadcontext
          * processhollow
          * modulestomping
    * dotNETInvoke (Supported File types: dotNET)
      * Module Variable: DOTNET_INVOKER_CMD
        * Description: Specify command line arguments for the dotNETInvoke executor.   
        * type: Optional 
        * Values: \<Any\>     
</details>

<details>
<summary>CI_TESTS</summary>

  * Description: Perform payload loading and execution tests and/or AV analysis Tests..  
  * Values:
    * exe_exec (Supported File types: PE)
    * ps_invoke (Supported File types: PS)
    * defendercheck (Supported File types: PE)
  * Module Variables:   
    * TEST_COMMAND_ARGS  
      * Description: When testing an EXE or Powershell you can use this variable to specify the command line arguments or the Powershell command after successful load.  
      * type: Optional  
      * Values: \<CMD\>  
</details>

<details>
<summary>CI_DEPLOYERS</summary>

  * Description: Specify destinations to upload your final payloads to.  
  * Values:
    * Pwndrop (Supported File types: All)
      * Module Variable: PWNDROP_CURL_CMD
        * Description: cURL command for your Pwndrop server. Make sure that the these instances IP addresses are whitelisted in file server.   
        * type: **Required** 
        * Values: curl -X POST -H "Authorization: \<Write-Key\>" -F "file=@path/to/file" https://\<HOSTNAME/IP\>/api/v1/files
</details>

<br />  
<br />   

**Framework Maintenance variables:**  
  
<details>
<summary>DOCKERFILE_BUILD_LINUX</summary>

  * Description: Build and push a dockerfile by specifying it's name prefix.  
  * Values: \<Dockerfile name - must be located under _ci-maintain/ci-container-builders/dockerfiles/linux/\>
</details>

<details>
<summary>HEALTH_CHECK</summary>

  * Description: Perform health checks to the framework. OS triggers, Gitlab DNS records from Pods, Variables checks, etc.  
  * Values: 1
      * Module Variable: DOCKERHUB_PRIVATE_CONTAINER_IMAGE
        * Description: Supply a Dockerhub private image to test your deployment's Dockerhub integration.
        * type: Optional 
        * Values: \<orgName/imageName:tagName\>
</details>

<details>
<summary>IMPORT_TOOLS</summary>

  * Description: Trigger tool import jobs to verify that all tools from ci-tools-controllers/.tools-index.json are imported to the relevant groups.  
  * Values: 1
</details>

<details>
<summary>DEPLOYMENT_INIT</summary>

  * Description: Initialize deployment with containers at GCR and import tools to instance. Enable if this is your first time running this pipeline after Terraform deployment.  
  * Values: 1
</details>


<br />
<br />

## Adding Tools / Designing Recipes

### Flow

1. Add a tool into the [tools index](ci-tools-controllers/.tools-index.json) and trigger the pipline that imports tools.
2. Design the tool's CI/CD recipe (YAML format), See examples under [tools controllers](ci-tools-controllers).
3. Optional - Code additional recipes to reference for additional needs. See examples under the different ci-XXXX directories.
4. Optional - Code, build and push relevant job recipe Dockerfile - [See Container-Builder](_ci-maintain/dockerfiles/README.md).
5. Add the pipeline's trigger job within the [Multipipeline trigger file](ci-multi-pipeline/multipipe-pick.yml).

The above can be done in **one** commit, but requires to be merged into the master branch of ScallOps-Recipes.


## Contribution

This project is developed and maintained by Sygnia's Adversarial Research team.
Your contributions are more than welcome!

The whole framework established with a main idea that enables security researchers to express their offensive techniques as a code. Coded techniques then can aid in creating modules that are referenced during the process of weaponizing offensive tools. Security teams will be able to upgrade their toolbox faster and save tremendous amount of time in the preparation for adversary simulation engagements.

Contributions can be made in code, as well as in any idea that you might think of. This includes further development, issues, optimizations, risks, usability, improvements, etc.
