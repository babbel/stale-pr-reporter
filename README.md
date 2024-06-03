# Stale Bot PR Notifier

## Overview
The **Stale Bot PR Notifier** is a GitHub Action designed to notify a Slack channel when pull requests from Dependabot and Renovate have become stale based on a specified timeframe. This action is useful for teams that want to keep track of aging PRs to ensure they are reviewed and merged in a timely manner.

## Features
- Checks for open pull requests from Dependabot and Renovate.
- Notifies a Slack channel if these PRs have been open longer than a specified number of hours.
- Configurable threshold for PR staleness.

## Inputs

### `pr_age_in_hours`
- **Description**: Total number of hours since the Pull Request (PR) was opened. If a PR exceeds this age, it will be considered stale.
- **Required**: No
- **Default**: 48 hours

### `slack_webhook_url`
- **Description**: The Slack webhook URL where notifications will be sent.
- **Required**: Yes

## Usage

### Setup
1. **Create a Slack Webhook**:
   - Navigate to your Slack App settings and create a new incoming webhook.
   - Copy the webhook URL which will be used to send notifications from this action.

2. **Add the GitHub Action to Your Repository**:
   - Create a directory `.github/workflows` in your repository if it doesn't already exist.
   - Add a new YAML file in this directory for the workflow, e.g., `stale-pr-notifier.yml`.

### Example Workflow File
Create a file named `.github/workflows/stale-pr-notifier.yml` and add the following content:
yaml name: Stale Bot PR Notifier
```
on:
  schedule:
    - cron: '0 * * * *' # Runs every hour, adjust as necessary

jobs:
  check-open-prs:
    runs-on: ubuntu-latest
    steps:
      - name: Notify Slack
        uses: babbel/stale-bot-pr-notifier@1.0.0
        with:
          slack_webhook_url: ${{ secrets.slack_webhook_url }}
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```
