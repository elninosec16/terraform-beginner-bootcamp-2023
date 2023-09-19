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

#### Github user credemtials issue while pushing the first commit

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
#### Issue #1 resolution: I have to go to my Github account settings and do the following:
  - un check the option: **"Keep my email addresses private"** for my email account 
  - Generate a new token in order to be able to push [^2].

### Support Links:

-[^1]:[ Semantic Versioning 2.0.0 ](https://semver.org/)
-[^2]:[ Managing your personal access tokens ](https://docs.github.com/en/enterprise-server@3.6/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)
