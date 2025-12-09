#!/usr/bin/env node
"use strict";

/**
 * Ultra-Simplified Compatibility Test Runner
 * 
 * Strategy: Directly replace upstream source files with HarmonyOS implementation,
 * then run upstream tests normally. This is much simpler than module interception.
 */

const fs = require('fs');
const path = require('path');
const { spawnSync } = require('child_process');

// Configuration
const ORIGINAL_REPO_PATH = path.resolve(__dirname, '../../protobuf-original');
const HARMONYOS_SRC_PATH = path.resolve(__dirname, '../library/src/main/ets/src');
const UPSTREAM_SRC_PATH = path.join(ORIGINAL_REPO_PATH, 'src');
const RESULTS_FILE = path.resolve(__dirname, '../test-results.txt');
const BACKUP_PATH = path.join(ORIGINAL_REPO_PATH, 'src-backup');

// Results tracking
const results = {
  total: 0,
  passed: 0,
  failed: 0
};

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
 * Remove directory recursively
 */
function removeDir(dir) {
  if (fs.existsSync(dir)) {
    const entries = fs.readdirSync(dir, { withFileTypes: true });
    
    for (const entry of entries) {
      const fullPath = path.join(dir, entry.name);
      
      if (entry.isDirectory()) {
        removeDir(fullPath);
      } else {
        fs.unlinkSync(fullPath);
      }
    }
    
    fs.rmdirSync(dir);
  }
}

/**
 * Main test execution
 */
function runTests() {
  console.log('=== HarmonyOS Compatibility Test ===\n');
  
  // Step 1: Verify paths
  console.log('Verifying paths...');
  if (!fs.existsSync(ORIGINAL_REPO_PATH)) {
    console.error(`Error: Original repo not found at ${ORIGINAL_REPO_PATH}`);
    process.exit(1);
  }
  
  if (!fs.existsSync(HARMONYOS_SRC_PATH)) {
    console.error(`Error: HarmonyOS source not found at ${HARMONYOS_SRC_PATH}`);
    process.exit(1);
  }
  
  if (!fs.existsSync(UPSTREAM_SRC_PATH)) {
    console.error(`Error: Upstream source not found at ${UPSTREAM_SRC_PATH}`);
    process.exit(1);
  }
  
  console.log('✓ All paths verified\n');
  
  // Step 2: Backup original source
  console.log('Backing up original source...');
  if (fs.existsSync(BACKUP_PATH)) {
    removeDir(BACKUP_PATH);
  }
  copyDir(UPSTREAM_SRC_PATH, BACKUP_PATH);
  console.log('✓ Backup complete\n');
  
  // Step 3: Replace with HarmonyOS implementation
  console.log('Replacing with HarmonyOS implementation...');
  removeDir(UPSTREAM_SRC_PATH);
  copyDir(HARMONYOS_SRC_PATH, UPSTREAM_SRC_PATH);
  console.log('✓ Source files replaced\n');
  
  // Step 4: Run tests
  console.log('Running upstream tests...\n');
  
  const testResult = spawnSync('npm', ['test'], {
    cwd: ORIGINAL_REPO_PATH,
    stdio: 'pipe',
    encoding: 'utf-8',
    env: {
      ...process.env,
      NODE_ENV: 'test'
    }
  });
  
  // Step 5: Restore original source
  console.log('\nRestoring original source...');
  removeDir(UPSTREAM_SRC_PATH);
  copyDir(BACKUP_PATH, UPSTREAM_SRC_PATH);
  removeDir(BACKUP_PATH);
  console.log('✓ Restore complete\n');
  
  // Step 6: Parse results
  const output = testResult.stdout + '\n' + testResult.stderr;
  console.log('=== Test Output ===');
  console.log(output);
  console.log('=== End Test Output ===\n');
  
  // Parse tape output format
  // Tape outputs lines like: "# tests 46", "# pass 26", "# fail 20"
  const testsMatch = output.match(/# tests\s+(\d+)/);
  const passMatch = output.match(/# pass\s+(\d+)/);
  const failMatch = output.match(/# fail\s+(\d+)/);
  
  if (testsMatch) results.total = parseInt(testsMatch[1], 10);
  if (passMatch) results.passed = parseInt(passMatch[1], 10);
  if (failMatch) results.failed = parseInt(failMatch[1], 10);
  
  // If parsing failed, try alternative format
  if (results.total === 0 && output.includes('ok') || output.includes('not ok')) {
    const lines = output.split('\n');
    results.total = lines.filter(l => l.match(/^(ok|not ok)/)).length;
    results.passed = lines.filter(l => l.match(/^ok/)).length;
    results.failed = lines.filter(l => l.match(/^not ok/)).length;
  }
  
  // Generate report
  console.log('=== Test Results Summary ===');
  console.log(`Total: ${results.total || 0}`);
  console.log(`Passed: ${results.passed || 0} (${Math.round((results.passed || 0) / (results.total || 1) * 100)}%)`);
  console.log(`Failed: ${results.failed || 0} (${Math.round((results.failed || 0) / (results.total || 1) * 100)}%)`);
  
  // Save detailed report
  let report = '=== Compatibility Test Report ===\n\n';
  report += `Total: ${results.total || 0} tests\n`;
  report += `Passed: ${results.passed || 0} tests (${Math.round((results.passed || 0) / (results.total || 1) * 100)}%)\n`;
  report += `Failed: ${results.failed || 0} tests (${Math.round((results.failed || 0) / (results.total || 1) * 100)}%)\n\n`;
  report += '=== Full Test Output ===\n\n';
  report += output;
  
  fs.writeFileSync(RESULTS_FILE, report, 'utf-8');
  console.log(`\n✓ Report saved to ${RESULTS_FILE}`);
  
  // Exit with appropriate code
  process.exit(results.failed > 0 ? 1 : 0);
}

// Run tests
try {
  runTests();
} catch (error) {
  console.error('Error running tests:', error.message);
  console.error(error.stack);
  
  // Try to restore backup if it exists
  if (fs.existsSync(BACKUP_PATH)) {
    console.log('\nAttempting to restore original source...');
    try {
      removeDir(UPSTREAM_SRC_PATH);
      copyDir(BACKUP_PATH, UPSTREAM_SRC_PATH);
      removeDir(BACKUP_PATH);
      console.log('✓ Source restored after error');
    } catch (restoreError) {
      console.error('Failed to restore source:', restoreError.message);
    }
  }
  
  process.exit(1);
}
