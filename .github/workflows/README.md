# Compatibility Testing

This directory contains scripts for testing API compatibility between this HarmonyOS adaptation and the original protobuf.js repository.

## Overview

The compatibility test workflow validates that the HarmonyOS-adapted version of protobufjs maintains API compatibility with the original protobuf.js library (master branch) using an **ultra-simplified direct source replacement approach**.

## Files

- **compatibility-test.yml**: GitHub Actions workflow that automatically runs compatibility tests
- **../scripts/simple-compatibility-test.js**: Ultra-simplified test runner using direct file replacement

## How It Works

### Ultra-Simplified Direct Replacement Approach

The test runner uses the simplest possible approach:

1. **Backup Original**: Save upstream's original source files to a backup directory
2. **Replace Source**: Copy HarmonyOS implementation files directly to upstream's `src/` directory
3. **Run Tests**: Execute upstream tests normally with `npm test`
4. **Restore**: Put original files back after testing

**Why This Works**:
- HarmonyOS implementation uses the same directory structure as upstream (`src/` folder)
- Tests import using `require('..')` which loads from the replaced source files
- No complex module interception or modification needed
- Just swap the implementation files and run the tests

### Workflow Steps

1. The workflow checks out both this repository and the original protobuf.js repository (master branch)
2. It installs necessary dependencies (tape, long, and npm packages)
3. The test runner:
   - Verifies all required paths exist
   - Backs up upstream's original `src/` directory
   - Copies HarmonyOS `library/src/main/ets/src/` to upstream's `src/`
   - Runs upstream's complete test suite with `npm test`
   - Restores the original source files
   - Parses test output and generates compatibility report

## Test Coverage

The test runner executes the complete upstream test suite, which includes all tests that pass/fail based on the implementation compatibility.

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
- Summary statistics (total, passed, failed) with percentages
- Full test output from upstream test suite
- List of passed tests
- List of failed tests with brief error messages
- List of skipped tests with reasons

## Design Philosophy

The simplified test approach prioritizes:
- **Reliability**: Minimal intervention reduces points of failure
- **Transparency**: Reports actual compatibility without hiding differences
- **Maintainability**: Simple code is easier to understand and modify
- **Accuracy**: Shows real compatibility status without artificial fixes
