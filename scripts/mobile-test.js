#!/usr/bin/env node

/**
 * RoboNeura Mobile Responsiveness Test
 * Run this script to check mobile-specific features
 */

const fs = require('fs');

console.log('📱 RoboNeura Mobile Responsiveness Test\n');

// Check if HTML file exists
if (!fs.existsSync('index.html')) {
  console.log('❌ index.html not found');
  process.exit(1);
}

const htmlContent = fs.readFileSync('index.html', 'utf8');

console.log('📄 Checking Mobile-Specific Elements:');

// Check for mobile navigation
const mobileChecks = [
  { 
    name: 'Mobile Menu Toggle', 
    pattern: /<button.*mobile-menu-toggle/i, 
    required: true 
  },
  { 
    name: 'Hamburger Icon', 
    pattern: /fa-bars/i, 
    required: true 
  },
  { 
    name: 'Close Icon', 
    pattern: /fa-times/i, 
    required: true 
  },
  { 
    name: 'Mobile Navigation Menu', 
    pattern: /id="nav-menu"/i, 
    required: true 
  },
  { 
    name: 'Viewport Meta Tag', 
    pattern: /<meta name="viewport"/i, 
    required: true 
  },
  { 
    name: 'Touch-Friendly CSS', 
    pattern: /@media.*max-width.*768px/i, 
    required: true 
  },
  { 
    name: 'Touch Interactions', 
    pattern: /@media.*hover.*none/i, 
    required: true 
  },
  { 
    name: 'Mobile JavaScript', 
    pattern: /mobileMenuToggle/i, 
    required: true 
  },
  { 
    name: 'Touch Event Handling', 
    pattern: /touchstart|touchmove|touchend/i, 
    required: true 
  },
  { 
    name: 'Mobile Optimization', 
    pattern: /optimizeForMobile/i, 
    required: true 
  }
];

mobileChecks.forEach(check => {
  const found = check.pattern.test(htmlContent);
  if (found) {
    console.log(`✅ ${check.name} - Found`);
  } else if (check.required) {
    console.log(`❌ ${check.name} - Missing (Required)`);
  } else {
    console.log(`⚠️  ${check.name} - Missing (Optional)`);
  }
});

// Check for responsive breakpoints
console.log('\n📱 Checking Responsive Breakpoints:');
const breakpointChecks = [
  { name: 'Desktop (1024px+)', pattern: /@media.*max-width.*1024px/i, required: false },
  { name: 'Tablet (768px)', pattern: /@media.*max-width.*768px/i, required: true },
  { name: 'Mobile (480px)', pattern: /@media.*max-width.*480px/i, required: true }
];

breakpointChecks.forEach(check => {
  const found = check.pattern.test(htmlContent);
  if (found) {
    console.log(`✅ ${check.name} - Found`);
  } else if (check.required) {
    console.log(`❌ ${check.name} - Missing (Required)`);
  } else {
    console.log(`⚠️  ${check.name} - Missing (Optional)`);
  }
});

// Check for mobile-specific features
console.log('\n🎯 Checking Mobile Features:');
const featureChecks = [
  { name: 'Smooth Scrolling', pattern: /behavior.*smooth/i, required: true },
  { name: 'Touch Event Prevention', pattern: /preventDefault/i, required: true },
  { name: 'Mobile Menu Animation', pattern: /transition.*ease/i, required: true },
  { name: 'Touch Highlight Removal', pattern: /tap-highlight-color.*transparent/i, required: true },
  { name: 'User Select Prevention', pattern: /user-select.*none/i, required: true }
];

featureChecks.forEach(check => {
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
console.log('\n📊 Mobile Responsiveness Summary:');
const totalChecks = mobileChecks.length + breakpointChecks.length + featureChecks.length;
const passedChecks = mobileChecks.filter(check => check.pattern.test(htmlContent)).length +
                    breakpointChecks.filter(check => check.pattern.test(htmlContent)).length +
                    featureChecks.filter(check => check.pattern.test(htmlContent)).length;

console.log(`Total Checks: ${totalChecks}`);
console.log(`Passed: ${passedChecks}`);
console.log(`Score: ${Math.round((passedChecks / totalChecks) * 100)}%`);

console.log('\n📱 Mobile Testing Recommendations:');
console.log('1. Test on actual mobile devices');
console.log('2. Check touch interactions');
console.log('3. Verify mobile navigation works');
console.log('4. Test 3D model performance on mobile');
console.log('5. Validate responsive breakpoints');
console.log('6. Check loading speed on mobile networks');

console.log('\n✨ Mobile responsiveness test complete!'); 