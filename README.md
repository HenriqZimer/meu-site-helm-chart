# Helm Chart for Fullstack Application

Production-ready Helm chart for deploying fullstack applications on Kubernetes.

## Description

This repository contains a Helm chart for deploying a complete fullstack application, including:

- Frontend (e.g., Vue.js, React, Angular)
- Backend (e.g., Node.js, Python, Go)
- MongoDB Database
- Configurable Ingress

## Features

✨ **Flexible Container Registry Support** - Works with Harbor, Docker Hub, GHCR, ECR, GCR, and any other registry  
🔐 **Secrets Management** - Supports both internal secrets and External Secrets Operator  
📦 **Multiple Storage Options** - PVC, hostPath, or emptyDir for database persistence  
🚀 **Production Ready** - Includes resource limits, health checks, and security best practices  
📝 **Well Documented** - Comprehensive documentation and examples

## Quick Start

### Prerequisites

- Kubernetes cluster (1.19+)
- Helm 3.x installed
- kubectl configured

### Install Chart

```bash
# Clone the repository
git clone <your-repository>
cd meu-site-helm-chart

# Install with default values
helm install myapp chart/

# Or install with custom values
helm install myapp chart/ -f custom-values.yaml
```

## Configuration

The main configuration is done through the `values.yaml` file. See the file for all available options.

### Quick Examples

```bash
# Install in specific namespace
helm install myapp chart/ --namespace myapp --create-namespace

# Upgrade release
helm upgrade myapp chart/

# Uninstall
helm uninstall myapp
```

## Development

```bash
# Validate the chart
make lint

# View generated manifests
make template

# Install locally
make install
```

## Project Structure

```
.
├── chart/              # Helm chart
│   ├── Chart.yaml      # Chart metadata
│   ├── values.yaml     # Default values
│   ├── README.md       # Chart documentation
│   └── templates/      # Kubernetes templates
├── examples/           # Example configurations
│   ├── values-dev.yaml
│   ├── values-production.yaml
│   └── values-dockerhub.yaml
├── LICENSE             # MIT License
├── Makefile            # Make commands
└── README.md           # This file
```

## Documentation

- **[QUICKSTART.md](QUICKSTART.md)** - Quick start guide
- **[chart/README.md](chart/README.md)** - Complete chart documentation
- **[REGISTRY_GUIDE.md](REGISTRY_GUIDE.md)** - Container registry usage guide
- **[EXAMPLES.md](EXAMPLES.md)** - Practical usage examples

## Using Different Container Registries

This chart supports any container registry. Simply specify the full image path:

```yaml
frontend:
  image:
    repository: docker.io/username/myapp-frontend  # Docker Hub
    # repository: harbor.example.com/project/myapp-frontend  # Harbor
    # repository: ghcr.io/username/myapp-frontend  # GitHub Container Registry
    tag: "v1.0.0"
```

See [REGISTRY_GUIDE.md](REGISTRY_GUIDE.md) for detailed instructions.

## License

MIT License - see [LICENSE](LICENSE) for details.

## Author

Henrique Zimermann
- Email: henrique.zimermann@outlook.com
- Website: https://henriqzimer.com.br
