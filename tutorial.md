# DevKTOps Docker Lab

<img src="https://raw.githubusercontent.com/devktops/gsh-docker-lab/master/banner.png" width="100%" alt="DevKTOps Docker Lab">

Welcome to the **Docker Fundamentals Lab** by DevKTOps! 🐳

In this lab you will practise the core Docker skills every engineer needs:
- Pulling images from Docker Hub
- Running and managing containers
- Building custom images with a Dockerfile
- Persisting data with volumes
- Connecting containers with custom networks

**Lab details**
- 5 tasks · 100 points total
- Estimated time: 30–45 minutes
- All work happens right here in Cloud Shell — nothing to install

Click **Start** to begin.

---

## Make the script executable

The lab is launched by a single shell script that pulls the Docker images and starts the environment.

First, give the script execute permission:

```bash
chmod +x ~/cloudshell_open/gsh-docker-lab/run.sh
```

---

## Start the lab

Run the setup script:

```bash
bash ~/cloudshell_open/gsh-docker-lab/run.sh
```

The script will:
1. Pull the lab Docker images (~300 MB on first run)
2. Start the portal, terminal, and grading API
3. Wait until everything is healthy

Watch for the **"Lab environment is ready!"** banner before moving on.

> ⏱ First run takes 2–4 minutes depending on your connection speed.

---

## Open the lab UI

Once you see the ready banner:

1. Click the **Web Preview** button (⊞ eye icon, top-right of the Cloud Shell toolbar)
2. Select **Preview on port 8080**

A new browser tab will open with the lab dashboard.

---

## Enter your access token

On the login screen, paste the access token below and click **Enter Lab**:

```
devktops-docker-2026
```

---

## Complete the tasks

The sidebar lists all 5 tasks. Select a task to read its requirements, then use the **terminal panel** on the right to run Docker commands.

When you think you've completed a task, click **Check Task**. You'll get instant feedback.

> **Hints** are available for each task at a cost of −10 points. Use them if you're stuck!

---

## Stop the lab

When you're done, clean up all containers and volumes:

```bash
cd ~/.devktops-lab && docker compose down --volumes
```

> Your Cloud Shell environment is preserved — only the lab containers are removed.

---

## You're all set!

Head back to the terminal, run the script, and start working through the tasks.

Good luck! 🚀
