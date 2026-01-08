# GitHub Actions Workflows

This directory contains automated workflows for maintaining the RustNet Chocolatey package.

## Workflows

### 1. Update Package (`update-package.yml`)

**Trigger:**
- Automatically triggered by the main RustNet release workflow
- Manual dispatch with version input

**Purpose:** Updates the Chocolatey package to a new RustNet version.

**What it does:**
1. Downloads the Windows binary for the specified version
2. Calculates the SHA256 checksum
3. Updates package files (nuspec, install script)
4. Builds and tests the package locally
5. Commits and pushes changes directly
6. Optionally publishes to Chocolatey Community Repository

**Manual trigger:**
```bash
gh workflow run update-package.yml -f version=0.19.0
```

With publishing enabled:
```bash
gh workflow run update-package.yml -f version=0.19.0 -f publish=true
```

**Parameters:**
- `version`: RustNet version to update to (e.g., `v0.19.0` or `0.19.0`)
- `publish`: Whether to publish to Chocolatey (default: false)

---

### 2. Publish Package (`publish-package.yml`)

**Trigger:**
- Manual dispatch only

**Purpose:** Manually publishes the current package to Chocolatey Community Repository.

**What it does:**
1. Builds the Chocolatey package from current files
2. Tests installation locally
3. Pushes to Chocolatey Community Repository

**Manual trigger:**
```bash
gh workflow run publish-package.yml -f confirm_publish=true
```

**Setup Requirements:**

Add your Chocolatey API key as a repository secret:

1. Go to: Settings → Secrets and variables → Actions
2. Create a new secret named `CHOCO_API_KEY`
3. Get your API key from: https://community.chocolatey.org/account

---

## Update Flow

### Automated Flow (Recommended)

When a new RustNet release is created:

1. **Tag Push** → Main rustnet release workflow runs
2. **Trigger** → Automatically triggers `update-package.yml` in this repo
3. **Update** → Package files are updated and committed
4. **Publish** → Optionally publishes to Chocolatey (if configured)

### Manual Flow

```bash
# Update to a specific version
gh workflow run update-package.yml -f version=0.19.0

# Update and publish in one step
gh workflow run update-package.yml -f version=0.19.0 -f publish=true

# Or publish the current version separately
gh workflow run publish-package.yml -f confirm_publish=true
```

---

## Required Secrets

| Secret | Repository | Purpose |
|--------|-----------|---------|
| `CHOCOLATEY_PAT` | domcyrus/rustnet | Trigger this workflow from release |
| `CHOCO_API_KEY` | This repo | Publish to Chocolatey Community |

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
