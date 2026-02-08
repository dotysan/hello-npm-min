# hello-npm-min
Testing minimalist NPM module

## Setup

### Creating an NPM Granular Access Token

Before automated publishing can work, you need to create an NPM granular access token and add it to GitHub.

**Note:** Classic tokens were revoked in December 2025. You must use granular access tokens.

1. **Log in to npmjs.com** and go to your account settings
2. **Access Tokens** → **Generate New Token** → **Granular Access Token**
3. Configure the token:
   - **Token name**: e.g., "GitHub Actions Publishing"
   - **Expiration**: Maximum 90 days for tokens with publish permissions (you'll need to rotate regularly)
   - **Packages and scopes**: Select the specific package(s) you want to publish
   - **Permissions**: Select **Read and write** (required for publishing)
   - **Organizations**: Select if publishing to an org scope
   - **Bypass 2FA**: Enable if using in CI/CD automation (recommended for GitHub Actions)
4. Click **Generate Token**
5. **Copy the token immediately** (you won't be able to see it again)

### Adding the Token to GitHub

1. Go to your repository on GitHub
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Name: `NODE_AUTH_TOKEN`
5. Value: Paste your NPM token
6. Click **Add secret**

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
