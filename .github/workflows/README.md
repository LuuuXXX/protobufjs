# Compatibility Testing

This directory contains scripts for testing API compatibility between this HarmonyOS adaptation and the original protobuf.js repository.

## Overview

The compatibility test workflow validates that the HarmonyOS-adapted version of protobufjs maintains API compatibility with the original protobuf.js library (master branch) using a simplified, non-intrusive testing approach.

## Files

- **compatibility-test.yml**: GitHub Actions workflow that automatically runs compatibility tests
- **../scripts/simple-compatibility-test.js**: Simplified test runner that runs upstream tests against HarmonyOS implementation

## How It Works

### Simplified Approach

The new test runner uses a minimal, non-intrusive approach:

1. **No Test Modification**: Tests from the upstream repository run unmodified
2. **Module Resolution Override**: Uses Node.js Module system to redirect `require('..')` calls to the HarmonyOS implementation
3. **Clean Execution**: Each test runs in isolation with proper environment setup
4. **Direct Reporting**: Reports pass/fail status without attempting to "fix" compatibility differences

### Workflow Steps

1. The workflow checks out both this repository and the original protobuf.js repository (master branch)
2. It installs necessary dependencies (tape, long, and npm packages)
3. The test runner:
   - Scans the original repository's test directory
   - Filters tests to include only API and compatibility tests (`api_*.js`, `comp_*.js`)
   - Skips CLI tests, library tests, and other non-API tests
   - Creates a minimal wrapper for each test that redirects module requires
   - Runs each test and collects results
   - Generates a detailed compatibility report

## Test Coverage

### Included Tests
- `api_*.js` - Core API functionality tests
- `comp_*.js` - Compatibility tests

### Excluded Tests
- `cli.js` - CLI functionality (not included in HarmonyOS adaptation)
- `lib_*.js` - Library-specific tests (handled through npm dependencies)
- `other_*.js`, `docs_*.js`, `feature_*.js` - Non-API tests

## Running Locally

To run compatibility tests locally:

```bash
# Clone the original protobuf.js repository
git clone https://github.com/protobufjs/protobuf.js.git ../protobuf-original

# Install dependencies
npm install -g tape long
cd ../protobuf-original && npm install && cd -

# Run the tests
node scripts/simple-compatibility-test.js
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
- Summary statistics (total, passed, failed, skipped) with percentages
- List of passed tests
- List of failed tests with brief error messages
- List of skipped tests with reasons

## Design Philosophy

The simplified test approach prioritizes:
- **Reliability**: Minimal intervention reduces points of failure
- **Transparency**: Reports actual compatibility without hiding differences
- **Maintainability**: Simple code is easier to understand and modify
- **Accuracy**: Shows real compatibility status without artificial fixes
