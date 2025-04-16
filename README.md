# The Bestagon Project

## Minikube Setup

### Pre-requisites
* minikube installed (`brew install minikube`)
* `kubectl` installed (`brew install kubectl`)

### Deployment Steps

1. Run minikube
```sh
minikube start
```

2. Use Minikube’s Docker daemon by default when running docker commands:
```
eval $(minikube docker-env)
```

3. Build docker image locally (we don't need to push it to Github Container Registry):
```
docker build -t bestagon-project ./app
```

4. Check resources are deployed:
```sh
kubectl get all
```

5. Access the app with:
```
minikube service bestagon-service
```

### Cleanup

K8s only:
```sh
kubectl delete -f k8s/
```

Full minikube reset:
```sh
minikube delete
```


---

## AWS EC2 Setup with Docker

This is a simple Node.js deployed on an AWS EC2 instance using Docker and Terraform.

### Pre-requisites
* AWS account with Free Tier access
* AWS IAM user with programmatic access & EC2 permissions
* AWS CLI installed and configured (aws configure)
* Terraform installed
* SSH key pair in AWS (key_name)

### Deployment steps

1. Build and push docker image (make sure its public)

```
docker build -t ghcr.io/YOUR_USERNAME/bestagon-project ./app
docker push ghcr.io/YOUR_USERNAME/bestagon-project
```

2. Set AWS credentials

```sh
export AWS_ACCESS_KEY_ID=xxx
export AWS_SECRET_ACCESS_KEY=xxx
export AWS_DEFAULT_REGION=eu-central-1
```

3. Apply terraform

```sh
cd terraform
terraform init
terraform apply \
  -var="key_name=your-key-pair-name" \
  -var="image_url=ghcr.io/YOUR_USERNAME/bestagon-project:latest"
```

4. Access app on http://`<public-ip>`/hello in your browser.
The IP is shown in the Terraform output.

### Cleanup

Remove the infra:
```sh
terraform destroy
```
