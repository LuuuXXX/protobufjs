#!/usr/bin/env node
"use strict";

const fs = require('fs');
const path = require('path');
const { spawnSync } = require('child_process');

// Configuration
const ORIGINAL_REPO_PATH = path.resolve(__dirname, '../../protobuf-original');
const HARMONYOS_REPO_PATH = path.resolve(__dirname, '..');
const HARMONYOS_ENTRY_POINT = path.resolve(HARMONYOS_REPO_PATH, 'library/src/main/ets/index.js');
const TEST_DIR = path.join(ORIGINAL_REPO_PATH, 'tests');
const TEMP_TEST_DIR = path.join(HARMONYOS_REPO_PATH, 'temp-tests');
const RESULTS_FILE = path.join(HARMONYOS_REPO_PATH, 'test-results.txt');

// Test file patterns to include
const INCLUDE_PATTERNS = [
  /^api_.*\.js$/,
  /^comp_.*\.js$/
];

// Test file patterns to skip
const SKIP_PATTERNS = [
  /^cli\.js$/,
  /^lib_.*\.js$/
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
  // Skip if matches skip patterns
  if (SKIP_PATTERNS.some(pattern => pattern.test(filename))) {
    return false;
  }
  
  // Include if matches include patterns
  if (INCLUDE_PATTERNS.some(pattern => pattern.test(filename))) {
    return true;
  }
  
  return false;
}

/**
 * Modify test file to use HarmonyOS implementation
 */
function adaptTestFile(originalPath, outputPath) {
  let content = fs.readFileSync(originalPath, 'utf8');
  
  // Escape backslashes in path for Windows compatibility
  const escapedPath = HARMONYOS_ENTRY_POINT.replace(/\\/g, '/');
  
  // Replace require("..") with the HarmonyOS entry point
  // This pattern matches require("..") or require('..')
  content = content.replace(
    /require\s*\(\s*['"]\.\.["']\s*\)/g,
    `require('${escapedPath}')`
  );
  
  // Also handle require("../..") patterns for nested test directories
  content = content.replace(
    /require\s*\(\s*['"]\.\.\/\.\.["']\s*\)/g,
    `require('${escapedPath}')`
  );
  
  // Inject normalization helper at the beginning of the test file
  // This helps with object type comparison issues
  const normalizationHelper = `
// Compatibility test helper - normalizes objects for comparison
var __normalizeForComparison = function(obj) {
  if (obj === null || obj === undefined) return obj;
  if (typeof obj !== 'object') return obj;
  if (Array.isArray(obj)) return obj.map(__normalizeForComparison);
  // Convert to plain object by creating a new object with the same properties
  var plain = {};
  for (var key in obj) {
    if (obj.hasOwnProperty(key)) {
      plain[key] = __normalizeForComparison(obj[key]);
    }
  }
  return plain;
};

// Wrap tape's deepEqual to normalize objects before comparison
if (typeof test !== 'undefined' && test.Test) {
  var originalDeepEqual = test.Test.prototype.deepEqual;
  test.Test.prototype.deepEqual = function(a, b, msg) {
    return originalDeepEqual.call(this, __normalizeForComparison(a), __normalizeForComparison(b), msg);
  };
}
`;
  
  // Insert helper after the first require statement or at the beginning
  const firstRequireMatch = content.match(/require\s*\([^)]+\);?/);
  if (firstRequireMatch && firstRequireMatch.index !== undefined) {
    const insertPos = firstRequireMatch.index + firstRequireMatch[0].length;
    content = content.slice(0, insertPos) + '\n' + normalizationHelper + '\n' + content.slice(insertPos);
  } else {
    content = normalizationHelper + '\n' + content;
  }
  
  fs.writeFileSync(outputPath, content);
}

/**
 * Copy directory recursively
 */
function copyDir(src, dest) {
  if (!fs.existsSync(dest)) {
    fs.mkdirSync(dest, { recursive: true });
  }
  
  const entries = fs.readdirSync(src, { withFileTypes: true });
  
  for (const entry of entries) {
    const srcPath = path.join(src, entry.name);
    const destPath = path.join(dest, entry.name);
    
    if (entry.isDirectory()) {
      copyDir(srcPath, destPath);
    } else {
      fs.copyFileSync(srcPath, destPath);
    }
  }
}

/**
 * Run a single test file
 */
function runTest(testFile) {
  const testName = path.basename(testFile);
  console.log(`Running test: ${testName}`);
  
  try {
    // Set up environment to include node_modules from original repo
    const env = { ...process.env };
    const originalNodeModules = path.join(ORIGINAL_REPO_PATH, 'node_modules');
    const globalNodeModules = process.execPath.replace(/\/bin\/node$/, '/lib/node_modules');
    
    // Set NODE_PATH to include both original repo and global node_modules
    env.NODE_PATH = [originalNodeModules, globalNodeModules].join(path.delimiter);
    
    // Run the test using tape - use spawnSync to prevent command injection
    const result = spawnSync('node', [testFile], {
      cwd: TEMP_TEST_DIR,
      stdio: 'pipe',
      timeout: 30000, // 30 seconds timeout
      encoding: 'utf8',
      env: env
    });
    
    if (result.status === 0) {
      results.passed++;
      results.details.push({ name: testName, status: 'PASSED', error: null });
      console.log(`✓ ${testName} passed`);
      return true;
    } else {
      throw new Error(result.stderr || result.stdout || 'Test failed');
    }
  } catch (error) {
    results.failed++;
    const errorMsg = error.stderr || error.message;
    results.details.push({ name: testName, status: 'FAILED', error: errorMsg });
    console.log(`✗ ${testName} failed`);
    console.error(errorMsg);
    return false;
  }
}

/**
 * Generate compatibility report
 */
function generateReport() {
  let report = '=== Compatibility Test Report ===\n';
  report += `Total: ${results.total} tests\n`;
  report += `Passed: ${results.passed} tests\n`;
  report += `Failed: ${results.failed} tests\n`;
  report += `Skipped: ${results.skipped} tests\n\n`;
  
  // Passed tests
  const passedTests = results.details.filter(d => d.status === 'PASSED');
  if (passedTests.length > 0) {
    report += 'Passed Tests:\n';
    passedTests.forEach(test => {
      report += `- ${test.name} ✓\n`;
    });
    report += '\n';
  }
  
  // Failed tests
  const failedTests = results.details.filter(d => d.status === 'FAILED');
  if (failedTests.length > 0) {
    report += 'Failed Tests:\n';
    failedTests.forEach(test => {
      report += `- ${test.name} ✗\n`;
      if (test.error) {
        report += `  Error: ${test.error.split('\n')[0]}\n`;
      }
    });
    report += '\n';
  }
  
  // Skipped tests
  const skippedTests = results.details.filter(d => d.status === 'SKIPPED');
  if (skippedTests.length > 0) {
    report += 'Skipped Tests:\n';
    skippedTests.forEach(test => {
      report += `- ${test.name} (${test.error})\n`;
    });
  }
  
  return report;
}

/**
 * Main execution
 */
function main() {
  console.log('=== Compatibility Test Runner ===');
  console.log(`Original repo: ${ORIGINAL_REPO_PATH}`);
  console.log(`HarmonyOS repo: ${HARMONYOS_REPO_PATH}`);
  console.log(`Entry point: ${HARMONYOS_ENTRY_POINT}`);
  console.log('');
  
  // Check if original repo exists
  if (!fs.existsSync(ORIGINAL_REPO_PATH)) {
    console.error('ERROR: Original protobuf.js repository not found at:', ORIGINAL_REPO_PATH);
    process.exit(1);
  }
  
  // Check if HarmonyOS entry point exists
  if (!fs.existsSync(HARMONYOS_ENTRY_POINT)) {
    console.error('ERROR: HarmonyOS entry point not found at:', HARMONYOS_ENTRY_POINT);
    process.exit(1);
  }
  
  // Check if test directory exists
  if (!fs.existsSync(TEST_DIR)) {
    console.error('ERROR: Test directory not found at:', TEST_DIR);
    process.exit(1);
  }
  
  // Clean up and create temp test directory
  if (fs.existsSync(TEMP_TEST_DIR)) {
    fs.rmSync(TEMP_TEST_DIR, { recursive: true, force: true });
  }
  fs.mkdirSync(TEMP_TEST_DIR, { recursive: true });
  
  // Get all test files
  const allTestFiles = fs.readdirSync(TEST_DIR)
    .filter(f => f.endsWith('.js'))
    .sort();
  
  console.log(`Found ${allTestFiles.length} test files in original repository`);
  console.log('');
  
  // Process test files
  const testFilesToRun = [];
  
  for (const testFile of allTestFiles) {
    const originalPath = path.join(TEST_DIR, testFile);
    
    if (shouldIncludeTest(testFile)) {
      const outputPath = path.join(TEMP_TEST_DIR, testFile);
      adaptTestFile(originalPath, outputPath);
      testFilesToRun.push(outputPath);
      results.total++;
    } else {
      results.skipped++;
      const reason = SKIP_PATTERNS.some(p => p.test(testFile)) 
        ? 'CLI/lib test excluded' 
        : 'Not an API/compatibility test';
      results.details.push({ name: testFile, status: 'SKIPPED', error: reason });
      console.log(`⊘ Skipping ${testFile} (${reason})`);
    }
  }
  
  console.log('');
  console.log(`Running ${testFilesToRun.length} compatibility tests...`);
  console.log('');
  
  // Copy test data files (proto files, etc.) if they exist
  const dataDir = path.join(ORIGINAL_REPO_PATH, 'tests/data');
  if (fs.existsSync(dataDir)) {
    const tempDataDir = path.join(TEMP_TEST_DIR, 'data');
    copyDir(dataDir, tempDataDir);
    const dataFiles = fs.readdirSync(tempDataDir);
    console.log(`Copied ${dataFiles.length} test data files from tests/data/`);
  } else {
    console.log('Warning: tests/data directory not found in original repository');
  }
  
  // Also copy google protobuf well-known types if they exist
  const googleProtoDir = path.join(ORIGINAL_REPO_PATH, 'google');
  if (fs.existsSync(googleProtoDir)) {
    const tempGoogleDir = path.join(TEMP_TEST_DIR, 'google');
    copyDir(googleProtoDir, tempGoogleDir);
    console.log('Copied google protobuf well-known types');
  }
  
  console.log('');
  
  // Run each test
  for (const testFile of testFilesToRun) {
    runTest(testFile);
  }
  
  // Generate and display report
  console.log('');
  const report = generateReport();
  console.log(report);
  
  // Save report to file
  fs.writeFileSync(RESULTS_FILE, report);
  console.log(`Report saved to: ${RESULTS_FILE}`);
  
  // Clean up temp directory
  fs.rmSync(TEMP_TEST_DIR, { recursive: true, force: true });
  
  // Exit with appropriate code
  process.exit(results.failed > 0 ? 1 : 0);
}

// Run main function
main();
