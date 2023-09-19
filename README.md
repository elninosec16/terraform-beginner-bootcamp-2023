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

#### Issue #1: Github user credemtials issue while pushing the first commit

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
#### Issue 1 resolution: I have to go to my Github account settings and do the following:
  - un check the option: **"Keep my email addresses private"** for my email account 
  - Generate a new token in order to be able to push [^2].

### Issue 2: Manual intervensation installing Terraform CLI

#### Issue 2 resolution: updaintg the Terraform CLI commands and modifying bash file permissions.  

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

### Modify the Gitpod.YML file

The *.Gipot.yml* file is required to be updated to successfully install the *Terraform CLI* after updating the Terraform CLI commands. Do not forget to review the *Gitpod Tasks Execution Order*[^5] fix the issue on the original code (replace the command init: with before:).

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
 
### Support Links:

[^1]:[ Semantic Versioning 2.0.0 ](https://semver.org/)

[^2]:[ Managing your personal access tokens ](https://docs.github.com/en/enterprise-server@3.6/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)

[^3]:[ How to install Terraform CLI ](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

[^4]:[ Linux file permission - Chmod ](https://en.wikipedia.org/wiki/Chmod)

[^5]:[ Gitpod Tasks Execution order ](https://www.gitpod.io/docs/configure/workspaces/tasks)