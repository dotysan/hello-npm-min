# hello-npm-min
Testing minimalist NPM module

## Setup

### Configuring Trusted Publishing (Recommended)

This repository uses **npm Trusted Publishing** with OIDC, which is the most secure way to publish packages from CI/CD. No npm tokens are needed!

**What is Trusted Publishing?**
- Uses OpenID Connect (OIDC) for authentication instead of long-lived tokens
- No secrets to manage or rotate
- Automatically includes provenance attestation
- Greatly reduces security risks

**Setup Steps:**

1. **On npmjs.com**, go to your package settings
2. Navigate to **Publishing** → **Trusted Publishers**
3. Click **Add Trusted Publisher**
4. Select **GitHub Actions** as the provider
5. Configure the publisher:
   - **GitHub Organization/Username**: Your GitHub username (e.g., `dotysan`)
   - **Repository Name**: Your repository name (e.g., `hello-npm-min`)
   - **Workflow File**: `publish.yml`
   - **Environment** (optional): Leave blank unless using GitHub environments
6. Click **Add**

That's it! No tokens to create or store. The GitHub Actions workflow will authenticate automatically using OIDC.

### Manual Publishing (Optional)

If you need to publish manually from your local machine, you'll need to create a granular access token:

1. **Log in to npmjs.com** and go to your account settings
2. **Access Tokens** → **Generate New Token** → **Granular Access Token**
3. Configure the token:
   - **Token name**: e.g., "Local Development Publishing"
   - **Expiration**: Maximum 90 days for tokens with publish permissions
   - **Packages and scopes**: Select the specific package(s) you want to publish
   - **Permissions**: Select **Read and write** (required for publishing)
   - **Organizations**: Select if publishing to an org scope
   - **2FA**: Do NOT enable bypass 2FA (use Trusted Publishing for CI/CD instead)
4. Click **Generate Token**
5. **Copy the token immediately** and use it with `npm login` or store in `.npmrc`

**Note:** Manual publishing does not include provenance attestation. Use the automated workflow for supply chain security.

## Publishing

### Automated Publishing (Recommended)

This package is automatically published to NPM when a version tag is pushed. **This is the recommended approach** because it includes cryptographic provenance attestation for supply chain security.

To publish a new version:

```bash
# Bump version (patch, minor, or major) - this updates package.json, commits, and creates a tag
npm version patch  # for bug fixes (0.1.1 -> 0.1.2)
npm version minor  # for new features (0.1.1 -> 0.2.0)
npm version major  # for breaking changes (0.1.1 -> 1.0.0)

# Push the commit and tag
git push --follow-tags
```

GitHub Actions will automatically build, test, and publish to NPM with provenance attestation.

### Manual Publishing

If you need to publish manually (not recommended - provenance won't be included):

```bash
npm run publish
```

**Note:** Manual publishing does not include provenance attestation because the `--provenance` flag only works in CI environments like GitHub Actions with OIDC support.

### About Provenance

The automated publishing workflow uses modern npm provenance features to ensure package authenticity and supply chain security. Provenance creates a cryptographic link between the published package and the source code repository, allowing users to verify the package's origin.
