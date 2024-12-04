# Sync Folder to Repository Action

## Overview
This GitHub Action allows you to synchronize a folder from one repository to a bi-directional sync repo

## Usage
Below is an example of how to use this action in a workflow:

```yaml
name: Sync Documentation to BiDi Sync Repo

on:
  workflow_dispatch:

jobs:
  sync-folder:
    runs-on: ubuntu-latest
    steps:
      - name: Sync documentation to BiDi Sync Repo
        uses: rossrdme/sync-folder-to-repo@0.0.3
        with:
          primary_repo_folder: "/toomuchlove"           # Required: Path in the primary repo to sync
          bidi_sync_repo: "yourusername/target-repo"    # Required: Target sync repository
          bidi_sync_folder: ""                          # Optional: Destination folder in target repo
          bidi_sync_branch: "main"                      # Required: Target branch in sync repo
          access_token: ${{ secrets.README_SYNC_PAT }}  # Required: Token with repository access
          
          # Optional parameters
          git_user_name: "ReadMe GitHub Actions Bot"    # Default: "GitHub Actions Bot"
          git_user_email: "noreply@readme.com"          # Default: "noreply@github.com"
```