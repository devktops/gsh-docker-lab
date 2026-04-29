# DevKTOps Docker Lab

A hands-on Docker fundamentals lab that runs entirely in the browser via
[Google Cloud Shell](https://cloud.google.com/shell). No local tooling required.

## Start the lab

Open [Google Cloud Shell](https://shell.cloud.google.com) and run:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/devktops/gsh-docker-lab/main/setup/run.sh)
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
cd ~/.devktops-lab && docker compose down
```
