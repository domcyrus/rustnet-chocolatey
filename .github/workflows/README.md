# GitHub Actions Workflows

This directory contains automated workflows for maintaining the RustNet Chocolatey package.

## Workflows

### 1. Check for New Release (`check-new-release.yml`)

**Trigger:**
- Scheduled daily at 9 AM UTC
- Manual dispatch

**Purpose:** Automatically detects new RustNet releases and triggers the update workflow.

**What it does:**
1. Checks the domcyrus/rustnet repository for new releases
2. Compares with the current package version
3. If a new version is found:
   - Triggers the update workflow
   - Creates a GitHub issue to track the update

**Manual trigger:**
```bash
gh workflow run check-new-release.yml
```

---

### 2. Update Package (`update-package.yml`)

**Trigger:**
- Manual dispatch with version input
- Triggered by `check-new-release.yml`

**Purpose:** Updates the Chocolatey package to a specific RustNet version.

**What it does:**
1. Downloads the Windows binary for the specified version
2. Calculates the SHA256 checksum
3. Updates all package files (nuspec, install script, verification)
4. Builds and tests the package
5. Creates a pull request with the changes
6. Uploads the built package as an artifact

**Manual trigger:**
```bash
gh workflow run update-package.yml -f version=0.15.0
```

Or via the GitHub UI: Actions → Update RustNet Package → Run workflow

**Parameters:**
- `version`: RustNet version to update to (e.g., `0.15.0`)

---

### 3. Publish Package (`publish-package.yml`)

**Trigger:**
- When a GitHub release is published in this repository
- Manual dispatch

**Purpose:** Publishes the Chocolatey package to the Chocolatey Community Repository.

**What it does:**
1. Builds the Chocolatey package
2. Tests installation locally
3. Pushes to Chocolatey Community Repository (requires `CHOCO_API_KEY` secret)
4. Uploads the package as an artifact
5. Comments on the related PR with publication status

**Setup Requirements:**

To enable automatic publishing, add your Chocolatey API key as a repository secret:

1. Go to: Settings → Secrets and variables → Actions
2. Create a new secret named `CHOCO_API_KEY`
3. Get your API key from: https://community.chocolatey.org/account
4. Paste the key as the secret value

**Manual trigger:**
```bash
gh workflow run publish-package.yml -f version=0.15.0
```

---

## Typical Update Flow

### Automated Flow

1. **Daily Check** → `check-new-release.yml` runs automatically
2. **New Version Detected** → Triggers `update-package.yml`
3. **PR Created** → Review and merge the PR
4. **Create Release** → Create a GitHub release with the version tag
5. **Auto Publish** → `publish-package.yml` publishes to Chocolatey

### Manual Flow

If you want to manually update to a specific version:

```bash
# Option 1: Trigger the update workflow
gh workflow run update-package.yml -f version=0.16.0

# Option 2: Use the PowerShell script locally
.\update-checksums.ps1 -Version "0.16.0" -Checksum "abc123..."
git add .
git commit -m "Update to v0.16.0"
git push
```

---

## Monitoring

- **Workflow runs:** Actions tab in the repository
- **Update issues:** Issues with the `new-release` label
- **PR status:** Pull requests from `update-rustnet-*` branches

---

## Troubleshooting

### Workflow fails to download binary

- Check that the version exists: https://github.com/domcyrus/rustnet/releases
- Verify the URL format matches: `rustnet-v{VERSION}-x86_64-pc-windows-msvc.zip`

### Package installation fails

- Review the test logs in the workflow run
- Check that the binary exists in the extracted ZIP
- Verify the executable name is `rustnet.exe`

### Publishing fails

- Ensure `CHOCO_API_KEY` secret is set
- Verify your API key is valid on chocolatey.org
- Check for validation errors in the workflow logs

### PR not created

- Check that the GitHub token has write permissions
- Verify no PR already exists for that version
- Review the workflow logs for errors
