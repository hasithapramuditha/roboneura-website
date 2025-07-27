#!/usr/bin/env node

/**
 * RoboNeura iPad Navigation Test
 * Run this script to check iPad-specific features and navigation
 */

const fs = require('fs');

console.log('📱 RoboNeura iPad Navigation Test\n');

// Check if HTML file exists
if (!fs.existsSync('index.html')) {
  console.log('❌ index.html not found');
  process.exit(1);
}

const htmlContent = fs.readFileSync('index.html', 'utf8');

console.log('📄 Checking iPad-Specific Elements:');

// Check for iPad-specific CSS
const ipadChecks = [
  { 
    name: 'iPad Breakpoint (769px-1024px)', 
    pattern: /@media.*min-width.*769px.*max-width.*1024px/i, 
    required: true 
  },
  { 
    name: 'iPad Portrait Orientation', 
    pattern: /@media.*orientation.*portrait/i, 
    required: true 
  },
  { 
    name: 'iPad Landscape Orientation', 
    pattern: /@media.*orientation.*landscape/i, 
    required: true 
  },
  { 
    name: 'Touch-Friendly Navigation', 
    pattern: /min-height.*44px/i, 
    required: true 
  },
  { 
    name: 'iPad Navigation Adjustments', 
    pattern: /nav-container.*padding/i, 
    required: true 
  },
  { 
    name: 'iPad Button Optimizations', 
    pattern: /cta-buttons.*btn.*padding/i, 
    required: true 
  },
  { 
    name: 'iPad Hero Section', 
    pattern: /hero-container.*grid-template-columns/i, 
    required: true 
  },
  { 
    name: 'iPad 3D Model Height', 
    pattern: /hero-3d.*height.*400px/i, 
    required: true 
  },
  { 
    name: 'Touch Event Handling', 
    pattern: /touchstart|touchmove|touchend/i, 
    required: true 
  },
  { 
    name: 'Viewport Meta Tag', 
    pattern: /<meta name="viewport"/i, 
    required: true 
  }
];

ipadChecks.forEach(check => {
  const found = check.pattern.test(htmlContent);
  if (found) {
    console.log(`✅ ${check.name} - Found`);
  } else if (check.required) {
    console.log(`❌ ${check.name} - Missing (Required)`);
  } else {
    console.log(`⚠️  ${check.name} - Missing (Optional)`);
  }
});

// Check for navigation-specific features
console.log('\n🧭 Checking Navigation Features:');
const navigationChecks = [
  { name: 'Desktop Navigation (1024px+)', pattern: /@media.*max-width.*1024px/i, required: true },
  { name: 'Tablet Navigation (768px-1024px)', pattern: /@media.*min-width.*769px.*max-width.*1024px/i, required: true },
  { name: 'Mobile Navigation (≤768px)', pattern: /@media.*max-width.*768px/i, required: true },
  { name: 'Hamburger Menu', pattern: /mobile-menu-toggle/i, required: true },
  { name: 'Navigation Links', pattern: /nav-menu.*a/i, required: true },
  { name: 'CTA Buttons', pattern: /cta-buttons/i, required: true },
  { name: 'Logo Element', pattern: /logo.*RoboNeura/i, required: true },
  { name: 'Smooth Scrolling', pattern: /behavior.*smooth/i, required: true }
];

navigationChecks.forEach(check => {
  const found = check.pattern.test(htmlContent);
  if (found) {
    console.log(`✅ ${check.name} - Found`);
  } else if (check.required) {
    console.log(`❌ ${check.name} - Missing (Required)`);
  } else {
    console.log(`⚠️  ${check.name} - Missing (Optional)`);
  }
});

// Check for responsive design patterns
console.log('\n📐 Checking Responsive Design:');
const responsiveChecks = [
  { name: 'Flexible Grid System', pattern: /grid-template-columns/i, required: true },
  { name: 'Responsive Typography', pattern: /font-size.*rem/i, required: true },
  { name: 'Flexible Spacing', pattern: /padding.*rem|margin.*rem/i, required: true },
  { name: 'Touch Targets', pattern: /min-height.*44px|min-width.*44px/i, required: true },
  { name: 'Orientation Support', pattern: /orientation.*portrait|orientation.*landscape/i, required: true },
  { name: 'Flexible Containers', pattern: /max-width.*1200px/i, required: true }
];

responsiveChecks.forEach(check => {
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
console.log('\n📊 iPad Navigation Summary:');
const totalChecks = ipadChecks.length + navigationChecks.length + responsiveChecks.length;
const passedChecks = ipadChecks.filter(check => check.pattern.test(htmlContent)).length +
                    navigationChecks.filter(check => check.pattern.test(htmlContent)).length +
                    responsiveChecks.filter(check => check.pattern.test(htmlContent)).length;

console.log(`Total Checks: ${totalChecks}`);
console.log(`Passed: ${passedChecks}`);
console.log(`Score: ${Math.round((passedChecks / totalChecks) * 100)}%`);

console.log('\n📱 iPad Testing Recommendations:');
console.log('1. Test on actual iPad devices (both orientations)');
console.log('2. Check navigation in portrait mode (768px width)');
console.log('3. Check navigation in landscape mode (1024px width)');
console.log('4. Verify touch interactions work properly');
console.log('5. Test 3D model performance on iPad');
console.log('6. Check button sizes and spacing');
console.log('7. Verify text readability on iPad screens');
console.log('8. Test navigation menu spacing and touch targets');

console.log('\n🎯 iPad-Specific Viewport Sizes:');
console.log('- iPad (Portrait): 768px × 1024px');
console.log('- iPad (Landscape): 1024px × 768px');
console.log('- iPad Pro (Portrait): 834px × 1112px');
console.log('- iPad Pro (Landscape): 1112px × 834px');

console.log('\n✨ iPad navigation test complete!'); 