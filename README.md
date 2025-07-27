# RoboNeura Website

A modern, responsive website for RoboNeura - a company specializing in AI, ML, Computer Vision, and IoT solutions.

## 🚀 Features

- **3D Robot Model**: Interactive 3D robot with mouse tracking
- **Responsive Design**: Works perfectly on all devices
- **Modern UI**: Clean, professional design with smooth animations
- **Performance Optimized**: Fast loading with optimized assets
- **SEO Friendly**: Proper meta tags and structure

## 🛠️ Technologies Used

- **HTML5**: Semantic markup
- **CSS3**: Modern styling with Flexbox and Grid
- **JavaScript**: Interactive features and animations
- **Three.js**: 3D graphics and WebGL rendering
- **Font Awesome**: Icons
- **Google Fonts**: Typography

## 📁 Project Structure

```
├── index.html          # Main HTML file
├── src/
│   └── logo.png        # Company logo
├── model/
│   └── Untitled.glb    # 3D robot model
├── vercel.json         # Vercel configuration
├── package.json        # Project metadata
└── README.md          # This file
```

## 🚀 CI/CD Deployment with GitHub Actions

### Automated Deployment Setup

This project includes GitHub Actions workflows for automated CI/CD deployment to Vercel.

#### 1. Initial Setup

1. **Push to GitHub**:
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/yourusername/roboneura-website.git
   git push -u origin main
   ```

2. **Get Vercel Credentials**:
   ```bash
   # Install Vercel CLI
   npm i -g vercel
   
   # Login to Vercel
   vercel login
   
   # Link your project (this will create .vercel directory)
   vercel link
   ```

3. **Get Required Secrets**:
   - **VERCEL_TOKEN**: Go to [Vercel Account Settings](https://vercel.com/account/tokens) → Create Token
   - **VERCEL_ORG_ID**: Found in `.vercel/project.json` after linking
   - **VERCEL_PROJECT_ID**: Found in `.vercel/project.json` after linking

4. **Add GitHub Secrets**:
   - Go to your GitHub repository → Settings → Secrets and variables → Actions
   - Add the following secrets:
     - `VERCEL_TOKEN`
     - `VERCEL_ORG_ID`
     - `VERCEL_PROJECT_ID`

#### 2. Workflow Features

**🔄 Automatic Deployment**:
- Deploys to production on push to `main` branch
- Creates preview deployments for pull requests
- Runs quality checks before deployment

**🔍 Quality Checks**:
- HTML validity check
- Security audit
- Performance monitoring
- File size optimization

**📱 Preview Environments**:
- Automatic preview URLs for pull requests
- Staging environment for testing
- Comment notifications with deployment status

#### 3. Manual Deployment Options

**Option A: Vercel CLI**
```bash
npm i -g vercel
vercel
```

**Option B: GitHub Integration**
- Connect repository in Vercel dashboard
- Automatic deployment on push

**Option C: Drag & Drop**
- Zip project and upload to Vercel dashboard

#### 4. Workflow Files

- `.github/workflows/deploy.yml` - Production deployment
- `.github/workflows/preview.yml` - Preview deployments
- `.github/workflows/quality-check.yml` - Quality assurance

#### 5. Deployment Triggers

- **Push to main/master** → Production deployment
- **Pull Request** → Preview deployment + Quality checks
- **Manual trigger** → Available in GitHub Actions tab

## 🔧 Local Development

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/roboneura-website.git
   cd roboneura-website
   ```

2. **Install dependencies** (optional):
   ```bash
   npm install
   ```

3. **Run locally**:
   ```bash
   npm run dev
   # or
   npx serve .
   ```

4. **Open in browser**:
   ```
   http://localhost:3000
   ```

## 📝 Customization

### Update Content
- Edit `index.html` to modify text content
- Update `src/logo.png` to change the logo
- Replace `model/Untitled.glb` with your 3D model

### Styling
- Modify CSS in the `<style>` section of `index.html`
- Update color scheme variables in CSS
- Adjust animations and transitions

### 3D Model
- Replace the GLB file in the `model/` directory
- Update the model path in the JavaScript code
- Adjust camera positions and lighting as needed

## 🌐 Environment Variables

No environment variables are required for this static site.

## 📊 Performance

- **Lighthouse Score**: 90+ (Performance, Accessibility, Best Practices, SEO)
- **First Contentful Paint**: < 1.5s
- **Largest Contentful Paint**: < 2.5s
- **Cumulative Layout Shift**: < 0.1

## 🔒 Security

- HTTPS enabled by default on Vercel
- Security headers configured in `vercel.json`
- XSS protection enabled
- Content type sniffing disabled

## 📞 Support

For questions or issues:
- Email: hello@roboneura.com
- LinkedIn: linkedin.com/company/roboneura

## 📄 License

MIT License - see LICENSE file for details.

---

**RoboNeura** - Merging Hardware Precision with Software Intelligence # Test deployment
# Test deployment
