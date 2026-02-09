#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Usage function
usage() {
    echo "Usage: $0 [patch|minor|major|auto]"
    echo ""
    echo "Arguments:"
    echo "  patch  - Bump patch version (0.1.1 -> 0.1.2) for bug fixes"
    echo "  minor  - Bump minor version (0.1.1 -> 0.2.0) for new features"
    echo "  major  - Bump major version (0.1.1 -> 1.0.0) for breaking changes"
    echo "  auto   - Automatically detect version bump from commit messages (default)"
    echo ""
    echo "Auto-detection uses conventional commits:"
    echo "  - 'fix:' commits → patch"
    echo "  - 'feat:' commits → minor"
    echo "  - 'BREAKING CHANGE:' or '!' after type → major"
    echo ""
    echo "Examples:"
    echo "  $0           # Auto-detect from commits"
    echo "  $0 auto      # Auto-detect from commits"
    echo "  $0 patch     # Force patch version"
    exit 1
}

# Function to detect version type from commits
detect_version_type() {
    echo -e "${BLUE}Analyzing commits to determine version bump...${NC}"
    
    # Get the last version tag
    LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
    
    if [ -z "$LAST_TAG" ]; then
        echo -e "${YELLOW}No previous tags found. Defaulting to patch release.${NC}"
        echo "patch"
        return
    fi
    
    echo -e "${YELLOW}Last version tag: $LAST_TAG${NC}"
    
    # Get commits since last tag
    COMMITS=$(git log $LAST_TAG..HEAD --pretty=format:"%s")
    
    if [ -z "$COMMITS" ]; then
        echo -e "${YELLOW}No commits since last tag. Defaulting to patch release.${NC}"
        echo "patch"
        return
    fi
    
    echo -e "${YELLOW}Commits since $LAST_TAG:${NC}"
    echo "$COMMITS" | while IFS= read -r commit; do
        echo "  - $commit"
    done
    echo ""
    
    # Check for breaking changes (major version)
    if echo "$COMMITS" | grep -qiE "^[a-z]+(\(.+\))?!:|BREAKING CHANGE:"; then
        echo -e "${GREEN}Found breaking changes → major version bump${NC}"
        echo "major"
        return
    fi
    
    # Check for new features (minor version)
    if echo "$COMMITS" | grep -qiE "^feat(\(.+\))?:"; then
        echo -e "${GREEN}Found new features → minor version bump${NC}"
        echo "minor"
        return
    fi
    
    # Check for fixes (patch version)
    if echo "$COMMITS" | grep -qiE "^fix(\(.+\))?:"; then
        echo -e "${GREEN}Found bug fixes → patch version bump${NC}"
        echo "patch"
        return
    fi
    
    # Default to patch if no conventional commits found
    echo -e "${YELLOW}No conventional commit prefixes found. Defaulting to patch release.${NC}"
    echo "patch"
}

# Determine version type
if [ $# -eq 0 ] || [ "$1" = "auto" ]; then
    VERSION_TYPE=$(detect_version_type)
else
    VERSION_TYPE=$1
    
    # Validate version type
    if [[ ! "$VERSION_TYPE" =~ ^(patch|minor|major)$ ]]; then
        echo -e "${RED}Error: Invalid version type '$VERSION_TYPE'${NC}"
        usage
    fi
    
    echo -e "${BLUE}Using manually specified version type: $VERSION_TYPE${NC}"
fi

echo ""
echo -e "${GREEN}Starting release process with $VERSION_TYPE version bump...${NC}"
echo ""

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo -e "${RED}Error: You have uncommitted changes. Please commit or stash them first.${NC}"
    git status --short
    exit 1
fi

# Ensure we're on the main branch for automated publishing
CURRENT_BRANCH=$(git branch --show-current)
echo -e "${YELLOW}Current branch: $CURRENT_BRANCH${NC}"

if [ "$CURRENT_BRANCH" != "main" ]; then
    echo -e "${RED}Error: Releases must be made from the 'main' branch${NC}"
    echo -e "${RED}Current branch is '$CURRENT_BRANCH'${NC}"
    echo -e "${YELLOW}Please checkout main branch: git checkout main${NC}"
    exit 1
fi

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
