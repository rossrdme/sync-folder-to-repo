#!/bin/bash
set -e

# Change to bidi-sync-repo directory
cd bidi-sync-repo

# Check if branch exists remotely
if ! git ls-remote --heads origin "$BIDI_SYNC_BRANCH" | grep -q "$BIDI_SYNC_BRANCH"; then
  echo "Creating new branch: $BIDI_SYNC_BRANCH"
  git checkout -b "$BIDI_SYNC_BRANCH"
  git push origin "$BIDI_SYNC_BRANCH"
fi

# Ensure we're on the target branch
git checkout "$BIDI_SYNC_BRANCH"

# Create destination path variable
DEST_PATH="$(pwd)/$BIDI_SYNC_FOLDER"

# Create destination directory if it doesn't exist
mkdir -p "$DEST_PATH"

# Check for changes
if [ -n "$(diff -r "../primary-repo$PRIMARY_REPO_FOLDER" "$DEST_PATH")" ]; then
  # If syncing to a subfolder, only clear that folder's contents
  if [ -n "$BIDI_SYNC_FOLDER" ]; then
    find "$DEST_PATH" -mindepth 1 -delete
  else
    # Clear contents of sync repo root (except .git)
    find . -mindepth 1 ! -regex '^./.git.*' -delete
  fi
  
  # Copy documentation from primary repo to sync repo
  cp -r "../primary-repo$PRIMARY_REPO_FOLDER"/* "$DEST_PATH"/
  
  # Configure git
  git config user.name "$GIT_USER_NAME"
  git config user.email "$GIT_USER_EMAIL"

  # Stage changes
  git add -A

  # Check for changes to commit
  if ! git diff --cached --quiet; then
    # Commit and push changes
    git commit -m "Sync documentation from primary repo. Triggered by ${GITHUB_SHA} Branch: ${GITHUB_REF#refs/heads/} Workflow: ${GITHUB_WORKFLOW}"
    git push origin "$BIDI_SYNC_BRANCH"
  else
    echo "No changes to commit."
  fi
else
  echo "No changes detected."
fi