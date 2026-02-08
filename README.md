# hello-npm-min
Testing minimalist NPM module

## Setup

### Creating an NPM Access Token

Before automated publishing can work, you need to create an NPM access token and add it to GitHub:

1. **Log in to npmjs.com** and go to your account settings
2. **Access Tokens** → **Generate New Token** → **Classic Token**
3. Select **Automation** token type (allows publishing from CI/CD)
4. Copy the token (you won't be able to see it again)

### Adding the Token to GitHub

1. Go to your repository on GitHub
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Name: `NODE_AUTH_TOKEN`
5. Value: Paste your NPM token
6. Click **Add secret**

## Publishing

This package is automatically published to NPM when a version tag is pushed. To publish a new version:

```bash
# Bump version (patch, minor, or major) - this updates package.json, commits, and creates a tag
npm version patch  # for bug fixes (0.1.1 -> 0.1.2)
npm version minor  # for new features (0.1.1 -> 0.2.0)
npm version major  # for breaking changes (0.1.1 -> 1.0.0)

# Push the commit and tag
git push --follow-tags
```

GitHub Actions will automatically build, test, and publish to NPM with provenance attestation.

The automated publishing uses modern npm provenance features to ensure package authenticity and supply chain security.
