# Compatibility Testing

This directory contains scripts for testing API compatibility between this HarmonyOS adaptation and the original protobuf.js repository.

## Overview

The compatibility test workflow validates that the HarmonyOS-adapted version of protobufjs maintains API compatibility with the original protobuf.js library (master branch).

## Files

- **compatibility-test.yml**: GitHub Actions workflow that automatically runs compatibility tests
- **../scripts/run-compatibility-tests.js**: Test runner script that adapts and runs tests from the original repository

## How It Works

1. The workflow checks out both this repository and the original protobuf.js repository
2. It installs necessary dependencies (tape, long, and npm packages)
3. The test runner script:
   - Scans the original repository's test directory
   - Filters tests to include only API and compatibility tests (`api_*.js`, `comp_*.js`)
   - Skips CLI tests and library tests (`cli.js`, `lib_*.js`)
   - Modifies test imports to point to this repository's entry point
   - Runs each test and collects results
   - Generates a detailed compatibility report

## Test Coverage

### Included Tests
- `api_*.js` - Core API functionality tests
- `comp_*.js` - Compatibility tests

### Excluded Tests
- `cli.js` - CLI functionality (not included in HarmonyOS adaptation)
- `lib_*.js` - Library-specific tests (handled through npm dependencies)

## Running Locally

To run compatibility tests locally:

```bash
# Clone the original protobuf.js repository
git clone https://github.com/protobufjs/protobuf.js.git ../protobuf-original

# Install dependencies
npm install -g tape long
cd ../protobuf-original && npm install && cd -

# Run the tests
node scripts/run-compatibility-tests.js
```

## Workflow Triggers

The compatibility test workflow runs on:
- Push to `master` or `main` branches
- Pull requests
- Manual trigger via GitHub Actions UI

## Test Results

Test results are:
- Displayed in the workflow console output
- Saved to `test-results.txt`
- Uploaded as a workflow artifact for later review

## Report Format

The compatibility report includes:
- Summary statistics (total, passed, failed, skipped)
- List of passed tests
- List of failed tests with error messages
- List of skipped tests with reasons
