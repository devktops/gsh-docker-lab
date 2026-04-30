# DevKTOps Docker Lab

A hands-on Docker fundamentals lab that runs entirely in the browser via
[Google Cloud Shell](https://cloud.google.com/shell). No local tooling required.

## Start the lab

Click the button below — Cloud Shell will clone the repo and open the step-by-step tutorial automatically:

[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://ssh.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/devktops/gsh-docker-lab.git&cloudshell_tutorial=tutorial.md&shellonly=true)

Or run directly from Cloud Shell without the tutorial:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/devktops/gsh-docker-lab/master/run.sh)
```

When the banner says **"Lab environment is ready!"**:
1. Click **Web Preview** (top-right toolbar) → **Preview on port 8080**
2. Enter the access token provided by your instructor

## Lab tasks

| # | Title                   | Points |
|---|-------------------------|--------|
| 1 | Pull a Docker Image     | 10     |
| 2 | Run a Container         | 20     |
| 3 | Build a Custom Image    | 30     |
| 4 | Work with Volumes       | 25     |
| 5 | Create a Custom Network | 15     |
|   | **Total**               | **100**|

## Stop the lab

```bash
cd ~/.devktops-lab && docker compose down --volumes
```
