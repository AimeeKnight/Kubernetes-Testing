#!/bin/bash

# Exit on error
set -e

echo "Starting Kubernetes cluster verification..."

# 1. Check cluster connection and version
echo "Testing cluster connectivity..."
kubectl cluster-info
kubectl version --short

# 2. Verify node status
echo -e "\nChecking node status..."
kubectl get nodes
kubectl describe nodes

# 3. Test basic pod deployment
echo -e "\nTesting basic pod deployment..."
kubectl apply -f test-deployment.yaml

# 4. Wait for pods to be ready
echo "Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod -l app=nginx-test --timeout=60s

# 5. Test pod connectivity
echo -e "\nTesting pod connectivity..."
kubectl expose deployment test-deployment --port=80 --type=NodePort
kubectl get svc test-deployment

# 6. Test namespace creation
echo -e "\nTesting namespace creation..."
kubectl create namespace test-namespace
kubectl get namespaces

# 7. Test pod logs and exec
echo -e "\nTesting pod logging and exec capabilities..."
TEST_POD=$(kubectl get pod -l app=nginx-test -o jsonpath="{.items[0].metadata.name}")
kubectl logs $TEST_POD
kubectl exec -it $TEST_POD -- nginx -v

# 8. Test scaling
echo -e "\nTesting scaling capabilities..."
kubectl scale deployment test-deployment --replicas=3
kubectl rollout status deployment/test-deployment

# 9. Test persistent volume creation
echo -e "\nTesting persistent volume capabilities..."
kubectl apply -f persistent-volume-claim.yaml

# 10. Verify CoreDNS and kube-proxy
echo -e "\nVerifying core services..."
kubectl get pods -n kube-system | grep -E 'coredns|kube-proxy'

# Cleanup
echo -e "\nCleaning up test resources..."
kubectl delete deployment test-deployment
kubectl delete service test-deployment
kubectl delete namespace test-namespace
kubectl delete pvc test-pvc

echo -e "\nCluster testing completed!"
