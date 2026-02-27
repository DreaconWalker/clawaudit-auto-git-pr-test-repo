# Setup: clawaudit-auto-git-pr-test-repo for ClawAudit PR testing

Use this repo to test the ClawAudit GitHub webhook (audit on PR + optional remediation PR).

---

## 1. Create the repo on GitHub

- Go to [GitHub New Repository](https://github.com/new).
- **Repository name:** `clawaudit-auto-git-pr-test-repo`
- **Visibility:** Public or Private (if private, ensure `GITHUB_TOKEN` has access).
- Do **not** add a README, .gitignore, or license (we already have them locally).
- Click **Create repository**.

---

## 2. Push this folder to GitHub

From your **surge-hackathon** project root:

```bash
cd clawaudit-auto-git-pr-test-repo
git init
git add README.md .gitignore SETUP.md
git commit -m "Initial commit: test repo for ClawAudit webhook"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/clawaudit-auto-git-pr-test-repo.git
git push -u origin main
```

Replace `YOUR_USERNAME` with your GitHub username or org.

---

## 3. Add the webhook in the new repo

1. In the repo: **Settings → Webhooks → Add webhook**.
2. **Payload URL:** your ClawAudit API base + `/webhook/github`  
   - Local with ngrok: `https://YOUR_NGROK_URL/webhook/github`  
   - Deployed: `https://YOUR_API_HOST/webhook/github`
3. **Content type:** `application/json`.
4. **Events:** **Let me select individual events** → check **Pull requests**.
5. **Add webhook**.

Ensure your ClawAudit backend is running and has `GITHUB_TOKEN` in `.env`.

---

## 4. Open a PR that adds the vulnerable contract

We need a PR with a **diff** (so the agent can audit it). Add the vulnerable contract in a new branch:

```bash
cd clawaudit-auto-git-pr-test-repo
git checkout -b add-vulnerable-contract
git add contracts/Vulnerable.sol
git commit -m "Add vulnerable bank contract (reentrancy)"
git push -u origin add-vulnerable-contract
```

Then on GitHub:

1. Open the repo → **Compare & pull request** for `add-vulnerable-contract`, or **Pull requests → New pull request**.
2. Base: `main`, compare: `add-vulnerable-contract`.
3. **Create pull request**.

---

## 5. What to expect

- Within 1–2 minutes, ClawAudit should:
  1. Post a **comment** on the PR with the security audit (findings, recommendations).
  2. If the report includes a **## Patched code** block and only one `.sol` file was changed, post a second comment and **open a remediation PR** (branch `clawaudit-fix-pr-<number>`) with the suggested fix.
- Check **Settings → Webhooks → your webhook → Recent Deliveries** if nothing appears (e.g. 200 vs 5xx).

---

## 6. Optional: test “synchronize”

Push another commit to the same PR branch; GitHub will send a `synchronize` event and ClawAudit will run again and post a new comment (and possibly another remediation PR if the branch name is reused after deletion).
