# GitOps Security Project with ArgoCD

This project demonstrates a GitOps workflow using ArgoCD with integrated security scanning at multiple stages of the pipeline.

## Project Structure

```
gitops-security-project/
├── .github/
│   └── workflows/
│       └── ci-cd.yaml         # GitHub Actions CI/CD pipeline
├── argocd/
│   └── application.yaml       # ArgoCD application definition
├── manifests/                 # Kubernetes manifests
│   ├── deployment.yaml
│   ├── namespace.yaml
│   └── service.yaml
├── security-checks/           # Security scanning scripts
│   ├── kubesec-scan.sh
│   └── trivy-scan.sh
├── .pre-commit-config.yaml    # Pre-commit hooks configuration
└── README.md
```

## Setup Instructions

### Prerequisites

- Kubernetes cluster (Minikube, kind, or a cloud provider)
- kubectl
- ArgoCD installed on the cluster
- Git
- GitHub account (for CI/CD)
- Pre-commit (optional, for local checks)

### Installation Steps

1. **Start your Kubernetes cluster**

   ```bash
   minikube start
   ```

2. **Install ArgoCD**

   ```bash
   kubectl create namespace argocd
   kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
   ```

3. **Access ArgoCD UI**

   ```bash
   kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'
   minikube service argocd-server -n argocd
   ```

   Get the initial admin password:
   ```bash
   kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
   ```

4. **Create a Git repository**

   Push this project to your GitHub repository:
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/yourusername/gitops-security-project.git
   git push -u origin main
   ```

5. **Apply the ArgoCD application**

   Update the repository URL in `argocd/application.yaml` with your actual repository URL, then:
   ```bash
   kubectl apply -f argocd/application.yaml
   ```

6. **Set up pre-commit hooks (optional)**

   ```bash
   pip install pre-commit
   pre-commit install
   ```

## Security Features

This project includes several security measures:

1. **Pre-commit hooks**: Run KubeSec scans before committing code
2. **CI/CD pipeline security**: GitHub Actions workflow with KubeSec and Trivy scanning
3. **GitOps with ArgoCD**: Ensures deployed state matches the desired state in Git
4. **Container vulnerability scanning**: Trivy scans container images for vulnerabilities
5. **Kubernetes manifest scanning**: KubeSec checks for security issues in Kubernetes manifests

## Usage

After setting up the project:

1. Make changes to the manifests in the `manifests/` directory
2. Commit and push changes to the repository
3. ArgoCD will automatically sync the changes to the cluster

## Extending the Project

- Add more security tools like SAST (SonarQube, Snyk)
- Implement policy enforcement with OPA/Gatekeeper
- Add compliance checks for specific standards (PCI-DSS, HIPAA, etc.)
- Implement secret scanning with tools like GitGuardian or TruffleHog

## Important Note About GitHub Actions Workflow

Due to GitHub token permissions, the GitHub Actions workflow file (`.github/workflows/ci-cd.yaml`) needs to be added manually to the repository. You can do this by:

1. Going to your GitHub repository: https://github.com/ThopuriSeetaramaiah/gitops-security-project
2. Clicking on "Actions" tab
3. Clicking on "New workflow"
4. Clicking on "set up a workflow yourself"
5. Copy the contents of the `.github/workflows/ci-cd.yaml` file from your local repository
6. Commit the new workflow file

Alternatively, you can update your GitHub token to include the `workflow` scope and then push the workflow file directly.
