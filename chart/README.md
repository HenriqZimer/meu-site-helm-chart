# Fullstack Application Helm Chart

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](../LICENSE)
[![Helm Version](https://img.shields.io/badge/Helm-v3-blue)](https://helm.sh)

Production-ready Helm chart for deploying fullstack applications on Kubernetes - frontend, backend, and MongoDB database.

## Installation

### Requirements

- Kubernetes 1.19+
- Helm 3.x
- PV provisioner support (for database persistence)

### Install from Helm Repository (Recommended)

```bash
# Add the Helm repository
helm repo add meu-site-helm https://henriqzimer.github.io/meu-site-helm-chart/
helm repo update

# Install the chart
helm install myapp meu-site-helm/meu-site

# Install with custom values
helm install myapp meu-site-helm/meu-site -f custom-values.yaml

# Install in specific namespace
helm install myapp meu-site-helm/meu-site --namespace myapp --create-namespace

# Install specific version
helm install myapp meu-site-helm/meu-site --version 1.0.0
```

## Configuration

### Main Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `frontend.replicaCount` | Number of frontend replicas | `1` |
| `frontend.image.repository` | Frontend container image | `docker.io/library/nginx` |
| `backend.replicaCount` | Number of backend replicas | `1` |
| `backend.image.repository` | Backend container image | `docker.io/library/node` |
| `database.enabled` | Enable MongoDB deployment | `true` |
| `database.persistence.enabled` | Enable persistent storage | `false` |
| `secrets.enabled` | Create internal secrets | `false` |
| `ingress.enabled` | Enable ingress | `false` |

### Secrets Configuration

The chart supports two modes for secrets management:

#### 1. Internal Secrets (enabled: true)

```yaml
secrets:
  enabled: true
  name: database-credentials
  data:
    MONGO_INITDB_ROOT_USERNAME: "admin"
    MONGO_INITDB_ROOT_PASSWORD: "changeme"
    MONGO_INITDB_DATABASE: "myapp_db"
    MONGODB_URI: "mongodb://admin:changeme@database:27017/myapp_db?authSource=admin"
```

#### 2. External Secrets (enabled: false - Recommended for production)

Use External Secrets Operator or create secrets manually:

```bash
kubectl create secret generic database-credentials \
  --from-literal=MONGO_INITDB_ROOT_USERNAME=admin \
  --from-literal=MONGO_INITDB_ROOT_PASSWORD=secretpassword \
  --from-literal=MONGO_INITDB_DATABASE=myapp_db \
  --from-literal=MONGODB_URI=mongodb://admin:secretpassword@database:27017/myapp_db?authSource=admin
```

### Database Persistence

```yaml
database:
  persistence:
    enabled: true
    type: pvc  # or 'hostPath' or 'emptyDir'
    size: 8Gi
    storageClass: ""  # Use default storage class
    accessMode: ReadWriteOnce
```

### Ingress Configuration

```yaml
ingress:
  enabled: true
  className: nginx
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
  hosts:
    - host: example.com
      paths:
        - path: /
          pathType: Prefix
          backend:
            service:
              name: frontend
              port: 80
        - path: /api
          pathType: Prefix
          backend:
            service:
              name: backend
              port: 5000
  tls:
    - secretName: example-tls
      hosts:
        - example.com
```

## Container Registry Configuration

This chart supports any container registry. Simply specify the full image path:

### Docker Hub

```yaml
frontend:
  image:
    repository: docker.io/username/myapp-frontend
    tag: "v1.0.0"
```

### Harbor

```yaml
frontend:
  image:
    repository: harbor.example.com/project/myapp-frontend
    tag: "v1.0.0"
```

### GitHub Container Registry

```yaml
frontend:
  image:
    repository: ghcr.io/username/myapp-frontend
    tag: "v1.0.0"
```

### AWS ECR

```yaml
frontend:
  image:
    repository: 123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp-frontend
    tag: "v1.0.0"
```

## Resources Created

This chart creates the following Kubernetes resources:

- **Deployments**: 3 (frontend, backend, database)
- **Services**: 3 (ClusterIP for each component)
- **Ingress**: 1 (configurable)
- **PersistentVolumeClaim**: 1 (for database, if enabled)
- **Secret**: 1 (optional, for database credentials)

## Usage Examples

### Local Development

```bash
helm install myapp ./chart \
  --set frontend.image.pullPolicy=IfNotPresent \
  --set backend.image.pullPolicy=IfNotPresent \
  --set secrets.enabled=true
```

### Production

```bash
helm install myapp ./chart \
  --namespace production \
  --create-namespace \
  --set frontend.replicaCount=3 \
  --set backend.replicaCount=2 \
  --set database.persistence.enabled=true \
  --set database.persistence.size=20Gi
```

### Upgrade

```bash
# Update the release
helm upgrade myapp ./chart

# Update with new values
helm upgrade myapp ./chart -f production-values.yaml
```

### Uninstall

```bash
helm uninstall myapp

# Note: PVC is not deleted automatically
# To delete data as well:
kubectl delete pvc database-pvc
```

## Troubleshooting

### View Generated Manifests

```bash
helm template myapp ./chart --debug
```

### Validate Chart

```bash
helm lint ./chart
```

### Check Release Status

```bash
helm status myapp
helm get values myapp
```

### Common Issues

**ImagePullBackOff**
- Check if you have access to the registry
- Verify imagePullSecrets if using private registry
- Confirm image repository and tag exist

**Database Connection Issues**
- Verify secret exists: `kubectl get secret database-credentials`
- Check environment variables in backend pod
- Ensure database service is running

## File Structure

```
chart/
├── Chart.yaml              # Chart metadata
├── values.yaml             # Default values
├── .helmignore             # Files ignored in package
├── README.md               # This documentation
└── templates/
    ├── _helpers.tpl        # Reusable helpers
    ├── frontend-deployment.yaml
    ├── frontend-service.yaml
    ├── backend-deployment.yaml
    ├── backend-service.yaml
    ├── database-deployment.yaml
    ├── database-service.yaml
    ├── database-secret.yaml
    ├── pvc.yaml
    └── ingress.yaml
```

## Advanced Configuration

### Using Different Registries Per Component

```yaml
frontend:
  image:
    repository: docker.io/username/frontend
    tag: "v1.0.0"

backend:
  image:
    repository: ghcr.io/username/backend
    tag: "v1.0.0"

database:
  image:
    repository: docker.io/mongo
    tag: "7"
```

### Environment Variables

```yaml
frontend:
  env:
    - name: API_URL
      value: "http://backend:5000"
    - name: TZ
      value: "UTC"

backend:
  env:
    - name: NODE_ENV
      value: "production"
    - name: LOG_LEVEL
      value: "info"
```

### Resource Limits

```yaml
frontend:
  resources:
    requests:
      cpu: 500m
      memory: 1Gi
    limits:
      cpu: 1000m
      memory: 2Gi
```

### Node Affinity

```yaml
affinity:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
      - matchExpressions:
        - key: node-type
          operator: In
          values:
          - application
```

## Security Best Practices

1. **Never commit secrets** to the repository
2. Use External Secrets Operator in production
3. Configure Network Policies appropriately
4. Keep images updated
5. Use HTTPS/TLS for external communication
6. Configure appropriate resource limits
7. Use isolated namespaces

## Contributing

This is a personal repository, but if you have access and want to contribute:

1. Fork and clone the repository
2. Create a feature branch
3. Make your changes
4. Test locally with `make lint` and `make template`
5. Submit a pull request

## License

MIT License - Copyright (c) 2026 Henrique Zimermann

## Author

**Henrique Zimermann**
- Email: henrique.zimermann@outlook.com
- Website: https://henriqzimer.com.br
- GitHub: [@HenriqZimer](https://github.com/HenriqZimer)

## Additional Resources

- [Helm Documentation](https://helm.sh/docs/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [MongoDB on Kubernetes](https://www.mongodb.com/kubernetes)
