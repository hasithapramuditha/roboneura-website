# 🚀 Vercel Deployment with GitHub CI/CD

This guide explains how to set up automated deployment for the RoboNeura website using GitHub Actions and Vercel.

## 📋 Prerequisites

- GitHub repository with your code
- Vercel account
- Node.js installed locally (for setup)

## 🔧 Quick Setup

### Option 1: Automated Setup (Recommended)

1. **Run the setup script**:
   ```bash
   ./scripts/setup-vercel.sh
   ```

2. **Follow the prompts** to link your project and get the required secrets.

### Option 2: Manual Setup

#### Step 1: Install and Configure Vercel CLI

```bash
# Install Vercel CLI
npm install -g vercel

# Login to Vercel
vercel login

# Link your project
vercel link
```

#### Step 2: Get Required Credentials

After running `vercel link`, you'll get a `.vercel/project.json` file. Extract these values:

```bash
# Get Project ID and Org ID
cat .vercel/project.json
```

You'll also need a Vercel token:
1. Go to [Vercel Account Settings](https://vercel.com/account/tokens)
2. Click "Create Token"
3. Give it a name (e.g., "GitHub Actions")
4. Copy the token

#### Step 3: Add GitHub Secrets

1. Go to your GitHub repository
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Add these secrets:
   - `VERCEL_TOKEN` - Your Vercel API token
   - `VERCEL_ORG_ID` - Your Vercel organization ID
   - `VERCEL_PROJECT_ID` - Your Vercel project ID

## 🔄 How It Works

### Workflow Files

1. **`.github/workflows/deploy.yml`**
   - Triggers on push to `main`/`master` and pull requests
   - Deploys to production on main branch pushes
   - Creates preview deployments for pull requests
   - Runs quality checks before deployment

2. **`.github/workflows/preview.yml`**
   - Dedicated workflow for pull request previews
   - Creates isolated preview environments
   - Comments with preview URLs

3. **`.github/workflows/quality-check.yml`**
   - Runs code quality checks
   - Validates HTML structure
   - Checks for security issues

### Deployment Triggers

| Event | Action | Environment |
|-------|--------|-------------|
| Push to `main` | Production deployment | Live site |
| Pull Request | Preview deployment | Preview URL |
| Manual trigger | Custom deployment | Specified environment |

## 🎯 Deployment Process

### 1. Code Push
When you push code to the main branch:

```bash
git add .
git commit -m "Update website content"
git push origin main
```

### 2. Automated Pipeline
1. **Checkout**: GitHub Actions checks out your code
2. **Setup**: Installs Node.js and dependencies
3. **Quality Checks**: Runs linting and validation
4. **Build**: Prepares the project for deployment
5. **Deploy**: Deploys to Vercel
6. **Notify**: Comments with deployment status

### 3. Preview Deployments
For pull requests:
- Creates a unique preview URL
- Automatically updates with new commits
- Provides feedback in PR comments

## 🔍 Monitoring Deployments

### GitHub Actions
- Go to your repository → **Actions** tab
- View workflow runs and their status
- Check logs for any issues

### Vercel Dashboard
- Visit [vercel.com/dashboard](https://vercel.com/dashboard)
- See deployment history
- Monitor performance metrics

### Deployment URLs
- **Production**: `https://your-project-name.vercel.app`
- **Preview**: `https://your-project-name-git-branch-username.vercel.app`

## 🛠️ Troubleshooting

### Common Issues

#### 1. "Vercel token not found"
- Ensure `VERCEL_TOKEN` is set in GitHub Secrets
- Verify the token is valid and not expired

#### 2. "Project not found"
- Check `VERCEL_PROJECT_ID` and `VERCEL_ORG_ID` in secrets
- Ensure the project is linked correctly

#### 3. "Build failed"
- Check the build logs in GitHub Actions
- Verify all dependencies are installed
- Ensure the build command is correct

#### 4. "Deployment timeout"
- Large files may cause timeouts
- Optimize images and assets
- Check Vercel's file size limits

### Debug Commands

```bash
# Test Vercel connection
vercel whoami

# Check project status
vercel ls

# View deployment logs
vercel logs

# Redeploy manually
vercel --prod
```

## 🔒 Security Best Practices

1. **Token Security**
   - Use environment-specific tokens
   - Rotate tokens regularly
   - Never commit tokens to code

2. **Access Control**
   - Limit token permissions
   - Use team tokens for organizations
   - Monitor token usage

3. **Deployment Security**
   - Enable branch protection rules
   - Require PR reviews
   - Use deployment environments

## 📊 Performance Optimization

### Before Deployment
- Optimize images (WebP format)
- Minify CSS and JavaScript
- Enable gzip compression
- Use CDN for static assets

### After Deployment
- Monitor Core Web Vitals
- Check Lighthouse scores
- Optimize based on analytics
- Set up performance alerts

## 🔄 Advanced Configuration

### Custom Domains
1. Add domain in Vercel dashboard
2. Configure DNS records
3. Enable HTTPS automatically

### Environment Variables
```bash
# Add environment variables in Vercel
vercel env add VARIABLE_NAME
```

### Build Hooks
```bash
# Create build hook for external triggers
vercel build-hook create
```

## 📞 Support

If you encounter issues:

1. **Check GitHub Actions logs** for detailed error messages
2. **Review Vercel deployment logs** in the dashboard
3. **Consult Vercel documentation** at [vercel.com/docs](https://vercel.com/docs)
4. **Contact support** if needed

## 🎉 Success!

Once set up, your deployment pipeline will:
- ✅ Automatically deploy on every push to main
- ✅ Create preview environments for PRs
- ✅ Run quality checks before deployment
- ✅ Provide feedback and URLs in comments
- ✅ Monitor deployment health

Your RoboNeura website will be live and automatically updated! 🚀 