#!/usr/bin/env node
"use strict";

/**
 * Simplified Compatibility Test Runner
 * 
 * This script runs upstream protobuf.js tests against the HarmonyOS implementation
 * using a minimal, non-intrusive approach.
 */

const fs = require('fs');
const path = require('path');
const { spawnSync } = require('child_process');

// Configuration
const ORIGINAL_REPO_PATH = path.resolve(__dirname, '../../protobuf-original');
const HARMONYOS_ENTRY_POINT = path.resolve(__dirname, '../library/src/main/ets/index.js');
const RESULTS_FILE = path.resolve(__dirname, '../test-results.txt');

// Test patterns
const INCLUDE_PATTERNS = [
  /^api_.*\.js$/,
  /^comp_.*\.js$/
];

const SKIP_PATTERNS = [
  /^cli\.js$/,
  /^lib_.*\.js$/,
  /^other_.*\.js$/,
  /^docs_.*\.js$/,
  /^gen_.*\.js$/,
  /^feature_.*\.js$/,
  /^comment_.*\.js$/
];

// Results tracking
const results = {
  total: 0,
  passed: 0,
  failed: 0,
  skipped: 0,
  details: []
};

/**
 * Check if a test file should be included
 */
function shouldIncludeTest(filename) {
  if (SKIP_PATTERNS.some(pattern => pattern.test(filename))) {
    return false;
  }
  return INCLUDE_PATTERNS.some(pattern => pattern.test(filename));
}

/**
 * Create a temporary wrapper that redirects requires to HarmonyOS implementation
 */
function createTestWrapper(originalTestPath) {
  const wrapperContent = `
// Wrapper to redirect protobufjs requires to HarmonyOS implementation
const harmonyOSProtobuf = require(${JSON.stringify(HARMONYOS_ENTRY_POINT)});

// Override the module cache to return HarmonyOS implementation
const originalRequire = require.cache[require.resolve('..')];
require.cache[require.resolve('..')] = {
  id: require.resolve('..'),
  exports: harmonyOSProtobuf,
  loaded: true
};

// Also try to intercept direct .. requires
const Module = require('module');
const originalResolveFilename = Module._resolveFilename;
Module._resolveFilename = function(request, parent, isMain) {
  if (request === '..' && parent && parent.filename && parent.filename.includes('tests')) {
    // Return path that resolves to our HarmonyOS implementation
    return ${JSON.stringify(HARMONYOS_ENTRY_POINT)};
  }
  return originalResolveFilename.call(this, request, parent, isMain);
};

// Now run the actual test
require(${JSON.stringify(originalTestPath)});
`;
  
  return wrapperContent;
}

/**
 * Run a single test file
 */
function runTest(testFile) {
  const testPath = path.join(ORIGINAL_REPO_PATH, 'tests', testFile);
  
  console.log(`Running: ${testFile}...`);
  
  // Create wrapper script in temp location
  const tempDir = path.join(__dirname, '../temp-test-wrapper');
  if (!fs.existsSync(tempDir)) {
    fs.mkdirSync(tempDir, { recursive: true });
  }
  
  const wrapperPath = path.join(tempDir, `wrapper_${testFile}`);
  const wrapperContent = createTestWrapper(testPath);
  fs.writeFileSync(wrapperPath, wrapperContent);
  
  // Set up environment
  const env = {
    ...process.env,
    NODE_PATH: [
      path.join(ORIGINAL_REPO_PATH, 'node_modules'),
      process.env.NODE_PATH || ''
    ].filter(Boolean).join(path.delimiter)
  };
  
  // Run the wrapper
  const result = spawnSync('node', [wrapperPath], {
    env,
    cwd: path.join(ORIGINAL_REPO_PATH, 'tests'),
    timeout: 30000,
    encoding: 'utf8'
  });
  
  // Clean up wrapper
  try {
    fs.unlinkSync(wrapperPath);
  } catch (e) {
    // Ignore cleanup errors
  }
  
  const passed = result.status === 0;
  
  results.total++;
  if (passed) {
    results.passed++;
    results.details.push({ file: testFile, status: 'passed' });
    console.log(`✓ ${testFile} passed`);
  } else {
    results.failed++;
    const error = result.stderr || result.stdout || 'Unknown error';
    results.details.push({ file: testFile, status: 'failed', error: error.slice(0, 500) });
    console.log(`✗ ${testFile} failed`);
    if (error) {
      console.log(`  Error: ${error.slice(0, 200)}...`);
    }
  }
  
  return passed;
}

/**
 * Main execution
 */
function main() {
  console.log('=== Protobuf.js Compatibility Test Runner ===\n');
  console.log(`Original repo: ${ORIGINAL_REPO_PATH}`);
  console.log(`HarmonyOS entry: ${HARMONYOS_ENTRY_POINT}\n`);
  
  // Verify paths exist
  if (!fs.existsSync(ORIGINAL_REPO_PATH)) {
    console.error(`Error: Original repository not found at ${ORIGINAL_REPO_PATH}`);
    process.exit(1);
  }
  
  if (!fs.existsSync(HARMONYOS_ENTRY_POINT)) {
    console.error(`Error: HarmonyOS entry point not found at ${HARMONYOS_ENTRY_POINT}`);
    process.exit(1);
  }
  
  const testsDir = path.join(ORIGINAL_REPO_PATH, 'tests');
  if (!fs.existsSync(testsDir)) {
    console.error(`Error: Tests directory not found at ${testsDir}`);
    process.exit(1);
  }
  
  // Get all test files
  const allFiles = fs.readdirSync(testsDir).filter(f => f.endsWith('.js'));
  
  // Separate included and skipped tests
  const testFiles = allFiles.filter(f => shouldIncludeTest(f));
  const skippedFiles = allFiles.filter(f => !shouldIncludeTest(f));
  
  console.log(`Found ${testFiles.length} tests to run, ${skippedFiles.length} to skip\n`);
  
  // Run each test
  testFiles.forEach(testFile => {
    try {
      runTest(testFile);
    } catch (error) {
      results.total++;
      results.failed++;
      results.details.push({ 
        file: testFile, 
        status: 'failed', 
        error: error.message 
      });
      console.log(`✗ ${testFile} crashed: ${error.message}`);
    }
  });
  
  // Generate report
  console.log('\n=== Test Results ===');
  console.log(`Total: ${results.total}`);
  console.log(`Passed: ${results.passed} (${Math.round(results.passed/results.total*100)}%)`);
  console.log(`Failed: ${results.failed} (${Math.round(results.failed/results.total*100)}%)`);
  console.log(`Skipped: ${skippedFiles.length}`);
  
  // Save detailed report
  let report = '=== Compatibility Test Report ===\n\n';
  report += `Total: ${results.total} tests\n`;
  report += `Passed: ${results.passed} tests (${Math.round(results.passed/results.total*100)}%)\n`;
  report += `Failed: ${results.failed} tests (${Math.round(results.failed/results.total*100)}%)\n`;
  report += `Skipped: ${skippedFiles.length} tests\n\n`;
  
  if (results.passed > 0) {
    report += 'Passed Tests:\n';
    results.details.filter(d => d.status === 'passed').forEach(d => {
      report += `- ${d.file} ✓\n`;
    });
    report += '\n';
  }
  
  if (results.failed > 0) {
    report += 'Failed Tests:\n';
    results.details.filter(d => d.status === 'failed').forEach(d => {
      report += `- ${d.file} ✗\n`;
      if (d.error) {
        report += `  Error: ${d.error.split('\n')[0]}\n`;
      }
    });
    report += '\n';
  }
  
  if (skippedFiles.length > 0) {
    report += 'Skipped Tests:\n';
    skippedFiles.forEach(f => {
      const reason = SKIP_PATTERNS.find(p => p.test(f));
      let reasonStr = 'Not an API/compatibility test';
      if (/^cli\.js$/.test(f) || /^lib_/.test(f)) {
        reasonStr = 'CLI/lib test excluded';
      }
      report += `- ${f} (${reasonStr})\n`;
    });
  }
  
  fs.writeFileSync(RESULTS_FILE, report);
  console.log(`\nReport saved to: ${RESULTS_FILE}`);
  
  // Exit with error if any tests failed
  process.exit(results.failed > 0 ? 1 : 0);
}

// Run main function
main();
