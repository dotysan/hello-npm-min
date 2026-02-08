# hello-npm-min
Testing minimalist NPM module

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
