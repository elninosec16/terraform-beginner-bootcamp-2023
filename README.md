# Terraform Beginner Bootcamp 2023

## Introduction

This README file will be use to keep track all of the documentations, resources and steps use to complete each of the tasks or to resolve any issues during the *Terraform Beginner Bootcamp 2023*. 

### Documentation steps to follow for each of the tasks.

It's very important to keep track all of the resources use to perform any of the tasks, resolve any issues, and try to share it when possible. 

- Create a new Issue on **Github** using a Issue number.
- Create a new branch inside each of the **Github Issue**
- Use Gitpod and VS Code to perform all of the changes requires
- Push and merge your changes in **Github**.
- Try to use the "Symantec Versioning 2.0.0"[^1] as reference for the branching tagging.  

### Issues found while working on any tasks:

#### <u>Issue #1</u>: Github user credemtials issue while pushing the first commit

While pushing the first commit, I encontered an issue with the Github account :thinking: This is the error message that I got:

```git
$ git push
git: 'credential-osxkeychain' is not a git command. See 'git --help'.
Username for 'https://github.com': elninosec16
Password for 'https://elninosec16@github.com': 
git: 'credential-osxkeychain' is not a git command. See 'git --help'.
Enumerating objects: 5, done.
Counting objects: 100% (5/5), done.
Delta compression using up to 16 threads
Compressing objects: 100% (3/3), done.
Writing objects: 100% (3/3), 743 bytes | 743.00 KiB/s, done.
Total 3 (delta 1), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (1/1), completed with 1 local object.
remote: error: GH007: Your push would publish a private email address.
remote: You can make your email public or disable this protection by visiting:
remote: http://github.com/settings/emails
To https://github.com/elninosec16/terraform-beginner-bootcamp-2023.git
 ! [remote rejected] 1-1_branch-tag-pr -> 1-1_branch-tag-pr (push declined due to email privacy restrictions)
error: failed to push some refs to 'https://github.com/elninosec16/terraform-beginner-bootcamp-2023.git'
```

##### <u>Resolution</u>: I have to go to my Github account settings and do the following:
  - un check the option: **"Keep my email addresses private"** for my email account 
  - Generate a new token in order to be able to push [^2].



#### <u>Issue 2</u>: Manual intervensation installing Terraform CLI

There is a bug with the current config on the *.gitpod.yml* file with some of the commands. This issue was created to troubleshoot and to update current config file. 

##### <u>Resolution</u>: updaintg the Terraform CLI commands and modifying bash file permissions.  

Based on the bootcamp content video and performing some online search about this issue, the have to update the following:
  - Update the Terraform CLI commands[^3].
  - Create a new Bash file to automate the Terraform CLI install.
  
  ```bash
  #!/usr/bin/env-bash

  sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl

  wget -O- https://apt.releases.hashicorp.com/gpg | \
  gpg --dearmor | \
  sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

  gpg --no-default-keyring \
  --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
  --fingerprint

  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
  https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
  sudo tee /etc/apt/sources.list.d/hashicorp.list

  sudo apt update

  sudo apt-get install terraform -y
  ```

  - Update the Bash file permissions to be able to run it without user intervention[^4].

  ```bash
  chmod 744 ./bin/installing_terraform_cli.sh
  ```

  #### <u>Issue 3</u>: Modify the Gitpod.YML file

The *.Gipot.yml* file is required to be updated to successfully install the *Terraform CLI* after updating the Terraform CLI commands. Do not forget to review the *Gitpod Tasks Execution Order* fix the issue on the original code (replace the command init: with before:).

```
tasks:
  - name: terraform
    before: |
      source ./bin/installing_terraform_cli
  - name: aws-cli
    env:
      AWS_CLI_AUTO_PROMPT: on-partial
    before: |
      cd /workspace
      curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
      unzip awscliv2.zip
      sudo ./aws/install
      cd $THEIA_WORKSPACE_ROOT
vscode:
  extensions:
    - amazonwebservices.aws-toolkit-vscode
    - hashicorp.terraform
```

#### <u>Issue 4:</u> Update Gitpod setting

While using GitPod workspace, it was noticed that the GitHub username/password credntials were required every time that a new pull/push was executed. This issue section will explain how to fix this. 
 
##### <u>Resolution:</u> Update Gitpod setting

In order to resolve the Gitpod permission issue, the *Git Providers*[^6] settings required to be modifed under to allow Git to work properly. The *Git Providers* settings needs to be modify under User Settings > [Git Providers](https://gitpod.io/user/integrations).

#### <u>Issue 5:</u> Create a new env var file

There was some issue with the current bash script for the install terraform CLI. A new root env var file was required to fix this. 
 
##### <u>Resolution:</u> Update Gitpod seting

To fix the issue with installing_terraform_cli bash file, a new env var required to be created. These are some of the steps used to fix this issue:

1. Create a new folder `.env.example` to define the new root env var:

    .env.example
       
        PROJECT_ROOT='/workspace/terraform-beginner-bootcamp-2023'
  
2. Update the install_terraform_cli.sh bash file with the following
  
     cd /workspace
     
     cd $PROJECT_ROOT

3. Define the env varibale 

      ```sh
      gp env PROJECT_ROOT='/workspace/terraform-beginner-bootcamp-2023'
      ```
  

4. To print the env variable

      ```sh
      echo $PROJECT_ROOT
      ```

#### <u>Issue 6:</u> AWS CLI Refactor

There was some issue with the current config for the `install_aws_cli` script. During this process, I will be fixing this issue by following some of the steps provided by the task video. 
 
##### <u>Resolution:</u> Following the following steps to fix all of the issues while installing AWS CLI.

1. Crate a new `install_aws_cli` inside the *bin* folder 
2. Mode the config for the `.gitpo.yml` file into the new file

  ```json
  cd /workspace

  rm -f '/workspace/awscliv2.zip'
  rm -rf '/workspace/aws'

  cd /workspace
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    cd $THEIA_WORKSPACE_ROOT

  aws sts get-caller-identity

  cd $PROJECT_ROOT
  ```
3. Set up new env var variables on the `gitpod.yml` file for the AWS_CLI config: 
  
  ```sh
  AWS_ACCESS_KEY_ID='AKIAIOSFODNN7EXAMPLE'
  AWS_SECRET_ACCESS_KEY='wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY'
  AWS_DEFAULT_REGION='us-west-2'
  ```
  >note:this is just an example config[^7] for the env var.

4. Configure AWS account access key env var for the AWS user for this bootcamp.
  
  - Configure the AWS CLI env var for testing

  ```sh
    export AWS_ACCESS_KEY_ID='AKIAIOSFODNN7EXAMPLE'
    export AWS_SECRET_ACCESS_KEY='wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY'
    export AWS_DEFAULT_REGION='us-west-2'
  ```

  - Configure the AWS CLI env var on GitPod

  ```sh
    gp env AWS_ACCESS_KEY_ID='AKIAIOSFODNN7EXAMPLE'
    gp eng AWS_SECRET_ACCESS_KEY='wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY'
    gp env AWS_DEFAULT_REGION='us-west-2'
  ```

  - Validate env var configuration:

  ```sh
  aws sts get-caller-identity

{
    "UserId": "AKIAIOSFODNN7EXAMPLE",
    "Account": "aws-acc-#",
    "Arn": "arn:aws:iam::account-#:user/aws-username"
}
  ``` 
  - Validate the env var values from bash:

  ```sh
    env | grep AWS_
  ```
   - Save all the changes and commit/push to GitHub.


#### <u>Task 7:</u> TF random_id bucket id

In this task, we will testing the Terraform (TF) environment and perform some TF commands from CLI. For this test, the TF `random_id[^9]` module will be used to generate and request output values for butcket id. These are the tasks to follow for the section:

1. Use `Terraform Registry[^8]` to find the TF code example.
2. Find the `TF code example for random_id` on TF Registry.
3. Configure the first TF code to test environment
4. Generate the random_string value by running the apply command
5. Display the random_string value using the outpout command


- Terraform important information when executing some of the `TF CLI commands`[^10]:

|| file/directory name || description ||
---
| .terraform (directory) | TF binary install |
| .terraform/providers/registry.terraform.io/hashicorp/random | TF binary directory created |
| terraform-provider-random_v3.5.1_x5 | terraform provider module installed (language `Go`) |
| .terraform.lock.hcl | terraform file created when running `terraform init` |

- Terraform files created when using terraform apply:
|| file/directory name || description ||
---
| {} terraform.tfstate (directory) | TF state file |
| terraform.tfstate.backup | backup of the terraform state file |


### <u>Support Links</u>:

- [^1]:[Semantic Versioning 2.0.0](https://semver.org/)

- [^2]:[Managing your personal access tokens](https://docs.github.com/en/enterprise-server@3.6/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)

- [^3]:[How to install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

- [^4]:[Linux file permission - Chmod](https://en.wikipedia.org/wiki/Chmod)

- [^5]:[Gitpod Tasks Execution order](https://www.gitpod.io/docs/configure/workspaces/tasks)

- [^6]:[Gitpod Authentication and GitHub Integration](https://www.gitpod.io/docs/configure/authentication)

- [^7]:[How to configure AWS CLI env var ](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

- [^8]:[Terraform Registry](https://registry.terraform.io/)

- [^9]:[Terraform random_id(Resource)](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id)

- [^10]:[Basic TF CL Commands](https://developer.hashicorp.com/terraform/cli/commands)