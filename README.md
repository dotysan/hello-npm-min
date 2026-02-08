# hello-npm-min
Testing minimalist NPM module

## Publishing

This package is automatically published to NPM when a version tag is pushed. The workflow:

1. Update the version in `package.json`
2. Commit the change: `git commit -am "Bump version to x.y.z"`
3. Create and push a version tag: `git tag vx.y.z && git push origin vx.y.z`
4. GitHub Actions will automatically build, test, and publish to NPM with provenance attestation

The automated publishing uses modern npm provenance features to ensure package authenticity and supply chain security.
