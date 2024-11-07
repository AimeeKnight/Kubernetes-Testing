# Kubernetes-Testing
Comprehensive testing script that verifies key aspects of your Kubernetes cluster. Here's what each section tests:

- Basic connectivity and version information
- Node status and health
- Pod deployment capabilities
- Service creation and networking
- Namespace management
- Logging and exec functionality
- Scaling operations
- Storage subsystem
- Core Kubernetes services

To use this script:

Save it to a file (e.g., test-cluster.sh)
Make it executable: `chmod +x test-cluster.sh`
Run it: `./test-cluster.sh`

The script includes cleanup steps to remove test resources after completion. If any step fails, the script will exit due to the set -e flag.
