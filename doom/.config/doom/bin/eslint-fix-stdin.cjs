#!/usr/bin/env node
// eslint-fix-stdin.cjs
// Read file content from stdin, fix with ESLint, write result to stdout.
// Usage: node eslint-fix-stdin.cjs <filepath>
// Apheleia passes the real filepath as the first argument so ESLint can
// resolve the correct config and parser for the file.

'use strict';

const fs = require('fs');
const path = require('path');

const filepath = process.argv[2];
if (!filepath) {
  process.stderr.write('Usage: eslint-fix-stdin.cjs <filepath>\n');
  process.exit(1);
}

const absPath = path.resolve(filepath);
const cwd = path.dirname(absPath);

// Resolve the ESLint binary from the project's own node_modules first,
// then fall back to a globally installed one.
function resolveEslintLib(startDir) {
  let dir = startDir;
  while (true) {
    const candidate = path.join(dir, 'node_modules', 'eslint', 'lib', 'eslint', 'eslint.js');
    if (fs.existsSync(candidate)) return path.join(dir, 'node_modules', 'eslint');
    const parent = path.dirname(dir);
    if (parent === dir) break;
    dir = parent;
  }
  // fall back to global
  try { return path.dirname(require.resolve('eslint/package.json')); } catch (_) {}
  return null;
}

const eslintPkg = resolveEslintLib(cwd);
if (!eslintPkg) {
  process.stderr.write('eslint-fix-stdin: could not find eslint\n');
  process.exit(1);
}

const { ESLint } = require(path.join(eslintPkg, 'lib', 'eslint', 'eslint.js'));

const chunks = [];
process.stdin.on('data', (d) => chunks.push(d));
process.stdin.on('end', async () => {
  const text = Buffer.concat(chunks).toString('utf8');
  try {
    const eslint = new ESLint({ fix: true, cwd });
    const results = await eslint.lintText(text, { filePath: absPath });
    const out = results[0];
    process.stdout.write(out.output ?? text);
  } catch (err) {
    // On error emit the original text unchanged so the buffer is not clobbered.
    process.stderr.write(`eslint-fix-stdin: ${err.message}\n`);
    process.stdout.write(text);
  }
});
