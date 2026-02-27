# clawaudit-auto-git-pr-test-repo

Test repo for ClawAudit GitHub webhook: open a PR that adds or changes Solidity code to trigger an automated audit and (optionally) a remediation PR.

## Quick test

1. Create a branch, add or change a `.sol` file (e.g. copy `contracts/Vulnerable.sol` from this repo).
2. Open a Pull Request to `main`.
3. ClawAudit will audit the diff, post a comment, and if it suggests a fix, open a remediation PR.

See **SETUP.md** in this repo for full setup (push to GitHub, webhook, first PR).
