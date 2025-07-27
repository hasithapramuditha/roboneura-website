#!/usr/bin/env node

/**
 * RoboNeura SEO Validation Script
 * Run this script to check basic SEO elements on your website
 */

const fs = require('fs');
const path = require('path');

console.log('🔍 RoboNeura SEO Validation Check\n');

// Check if required files exist
const requiredFiles = [
  'index.html',
  'sitemap.xml',
  'robots.txt',
  'manifest.json'
];

console.log('📁 Checking Required Files:');
requiredFiles.forEach(file => {
  if (fs.existsSync(file)) {
    console.log(`✅ ${file} - Found`);
  } else {
    console.log(`❌ ${file} - Missing`);
  }
});

// Check HTML for SEO elements
console.log('\n📄 Checking HTML SEO Elements:');
const htmlContent = fs.readFileSync('index.html', 'utf8');

const seoChecks = [
  { name: 'Title Tag', pattern: /<title>.*<\/title>/i, required: true },
  { name: 'Meta Description', pattern: /<meta name="description"/i, required: true },
  { name: 'Meta Keywords', pattern: /<meta name="keywords"/i, required: true },
  { name: 'Canonical URL', pattern: /<link rel="canonical"/i, required: true },
  { name: 'Open Graph Tags', pattern: /<meta property="og:/i, required: true },
  { name: 'Twitter Cards', pattern: /<meta property="twitter:/i, required: true },
  { name: 'Structured Data', pattern: /<script type="application\/ld\+json">/i, required: true },
  { name: 'Favicon', pattern: /<link rel="icon"/i, required: true },
  { name: 'Viewport Meta', pattern: /<meta name="viewport"/i, required: true },
  { name: 'Charset Meta', pattern: /<meta charset="UTF-8"/i, required: true },
  { name: 'Manifest Link', pattern: /<link rel="manifest"/i, required: true },
  { name: 'Preload Hints', pattern: /<link rel="preload"/i, required: false },
  { name: 'DNS Prefetch', pattern: /<link rel="dns-prefetch"/i, required: false }
];

seoChecks.forEach(check => {
  const found = check.pattern.test(htmlContent);
  if (found) {
    console.log(`✅ ${check.name} - Found`);
  } else if (check.required) {
    console.log(`❌ ${check.name} - Missing (Required)`);
  } else {
    console.log(`⚠️  ${check.name} - Missing (Optional)`);
  }
});

// Check for semantic HTML elements
console.log('\n🏗️  Checking Semantic HTML:');
const semanticChecks = [
  { name: 'Header Element', pattern: /<header/i, required: true },
  { name: 'Nav Element', pattern: /<nav/i, required: true },
  { name: 'Main Element', pattern: /<main/i, required: false },
  { name: 'Section Elements', pattern: /<section/i, required: true },
  { name: 'Footer Element', pattern: /<footer/i, required: true },
  { name: 'H1 Tag', pattern: /<h1/i, required: true },
  { name: 'H2 Tags', pattern: /<h2/i, required: true },
  { name: 'Alt Attributes', pattern: /alt=/i, required: true }
];

semanticChecks.forEach(check => {
  const found = check.pattern.test(htmlContent);
  if (found) {
    console.log(`✅ ${check.name} - Found`);
  } else if (check.required) {
    console.log(`❌ ${check.name} - Missing (Required)`);
  } else {
    console.log(`⚠️  ${check.name} - Missing (Optional)`);
  }
});

// Performance checks
console.log('\n⚡ Performance Checks:');
const performanceChecks = [
  { name: 'External CSS', pattern: /<link.*\.css/i, required: true },
  { name: 'External JS', pattern: /<script.*\.js/i, required: false },
  { name: 'Inline Styles', pattern: /<style>/i, required: false },
  { name: 'Inline Scripts', pattern: /<script>/i, required: false }
];

performanceChecks.forEach(check => {
  const found = check.pattern.test(htmlContent);
  if (found) {
    console.log(`✅ ${check.name} - Found`);
  } else if (check.required) {
    console.log(`❌ ${check.name} - Missing (Required)`);
  } else {
    console.log(`⚠️  ${check.name} - Missing (Optional)`);
  }
});

// Summary
console.log('\n📊 SEO Summary:');
const totalChecks = seoChecks.length + semanticChecks.length + performanceChecks.length;
const passedChecks = seoChecks.filter(check => check.pattern.test(htmlContent)).length +
                    semanticChecks.filter(check => check.pattern.test(htmlContent)).length +
                    performanceChecks.filter(check => check.pattern.test(htmlContent)).length;

console.log(`Total Checks: ${totalChecks}`);
console.log(`Passed: ${passedChecks}`);
console.log(`Score: ${Math.round((passedChecks / totalChecks) * 100)}%`);

console.log('\n🎯 Next Steps:');
console.log('1. Submit sitemap to Google Search Console');
console.log('2. Test structured data with Google Rich Results Test');
console.log('3. Run Lighthouse audit for performance');
console.log('4. Monitor Core Web Vitals');
console.log('5. Set up Google Analytics tracking');

console.log('\n✨ SEO validation complete!'); 