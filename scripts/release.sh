#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Usage function
usage() {
    echo "Usage: $0 [patch|minor|major]"
    echo ""
    echo "Arguments:"
    echo "  patch  - Bump patch version (0.1.1 -> 0.1.2) for bug fixes"
    echo "  minor  - Bump minor version (0.1.1 -> 0.2.0) for new features"
    echo "  major  - Bump major version (0.1.1 -> 1.0.0) for breaking changes"
    echo ""
    echo "Example:"
    echo "  $0 patch"
    exit 1
}

# Check if argument is provided
if [ $# -eq 0 ]; then
    echo -e "${RED}Error: Version type not specified${NC}"
    usage
fi

VERSION_TYPE=$1

# Validate version type
if [[ ! "$VERSION_TYPE" =~ ^(patch|minor|major)$ ]]; then
    echo -e "${RED}Error: Invalid version type '$VERSION_TYPE'${NC}"
    usage
fi

echo -e "${GREEN}Starting release process...${NC}"
echo ""

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo -e "${RED}Error: You have uncommitted changes. Please commit or stash them first.${NC}"
    git status --short
    exit 1
fi

# Make sure we're on the main/master branch (optional, can be removed if you want to release from any branch)
CURRENT_BRANCH=$(git branch --show-current)
echo -e "${YELLOW}Current branch: $CURRENT_BRANCH${NC}"

# Run tests to make sure everything is working
echo -e "${YELLOW}Running tests...${NC}"
npm test

# Build the project
echo -e "${YELLOW}Building project...${NC}"
npm run build

# Bump version - this will update package.json, create a commit, and create a tag
echo -e "${YELLOW}Bumping $VERSION_TYPE version...${NC}"
npm version $VERSION_TYPE

# Get the new version
NEW_VERSION=$(node -p "require('./package.json').version")
echo -e "${GREEN}New version: v$NEW_VERSION${NC}"

# Push the commit and tag
echo -e "${YELLOW}Pushing changes and tags to remote...${NC}"
git push --follow-tags

echo ""
echo -e "${GREEN}✓ Release successful!${NC}"
echo -e "${GREEN}✓ Version v$NEW_VERSION has been tagged and pushed${NC}"
echo -e "${GREEN}✓ GitHub Actions will now build, test, and publish to npm${NC}"
echo ""
echo -e "Track the workflow at: https://github.com/$(git config --get remote.origin.url | sed 's/.*github.com[:/]\(.*\)\(\.git\)\?/\1/')/actions"
