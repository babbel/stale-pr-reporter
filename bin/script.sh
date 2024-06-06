#!/bin/bash

# Install jq for JSON processing
sudo apt-get install jq -y

# Get all the open PRs in the repository
PR_LIST=$(gh pr list --repo $repository --state open --json "number,url,createdAt,author" | jq -c '.[]' | \
  while read pr; do
    author=$(echo $pr | jq -r '.author.login')
    url=$(echo $pr | jq -r '.url')
    pr_created_at=$(echo $pr | jq -r '.createdAt')

    # Convert PR creation date to Unix timestamp (seconds since 1970-01-01 00:00:00 UTC)
    pr_created_at_unix=$(date -d "$pr_created_at" +%s)

    # Get current date in Unix timestamp
    current_unix=$(date +%s)

    # Calculate the age of the PR in hours
    pr_age=$(( (current_unix - pr_created_at_unix) / 3600 ))

    if [[ ("$author" == "app/dependabot" || "$author" == "app/lessonnine-renovate") && "$pr_age" -gt $pr_age_in_hours ]]; then
      echo "$url"
    fi
  done)

  # Check if PR_LIST is empty
  if [ -z "$PR_LIST" ]; then
    echo "No open PRs found."
  else
    # Create a JSON payload file
    jq -n \
      --arg repository "$repository" \
      --arg pr_list "$PR_LIST" \
      --arg pr_age_in_hours "$pr_age_in_hours" \
      '{
        repository: $repository,
        pr_list: $pr_list,
        pr_age_in_hours: $pr_age_in_hours
      }' > payload.json
    PR_LIST="true"
  fi

echo "PR_LIST=$PR_LIST" >> $GITHUB_ENV
