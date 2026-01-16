name: Terraform + Kubernetes CI

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
    # -------------------------
    # STEP 1: Checkout code
    # -------------------------
    - name: Checkout repository
      uses: actions/checkout@v4

    # -------------------------
    # STEP 2: Install Docker
    # -------------------------
    - name: Install Docker
      uses: docker/setup-buildx-action@v3

    # -------------------------
    # STEP 3: Install kind (Kubernetes in Docker)
    # -------------------------
    - name: Install kind
      run: |
        curl -Lo kind https://kind.sigs.k8s.io/dl/v0.31.0/kind-linux-amd64
        chmod +x kind
        sudo mv kind /usr/local/bin/kind

    # -------------------------
    # STEP 4: Create kind cluster
    # -------------------------
    - name: Create Kubernetes cluster
      run: |
        kind create cluster
        kubectl cluster-info

    # -------------------------
    # STEP 5: Install Terraform
    # -------------------------
    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v3

    # -------------------------
    # STEP 6: Terraform Init
    # -------------------------
    - name: Terraform Init
      run: terraform init

    # -------------------------
    # STEP 7: Terraform Apply (Deploy Nginx + MySQL)
    # -------------------------
    - name: Terraform Apply
      run: terraform apply -auto-approve

    # =================================================
    # ✅ STEP 8: WAIT FOR MYSQL (THIS IS THE STEP YOU ASKED ABOUT)
    # =================================================
    - name: Wait for MySQL Pod to be Ready
      run: |
        kubectl wait --for=condition=ready pod -l app=mysql --timeout=120s

    # =================================================
    # ✅ STEP 9: AUTOMATED SQL QUERY VALIDATION
    # =================================================
    - name: Validate MySQL using SQL query
      run: |
        MYSQL_POD=$(kubectl get pods -l app=mysql -o jsonpath="{.items[0].metadata.name}")
        kubectl exec $MYSQL_POD -- \
          mysql -uroot -ppassword -e "SELECT 1;"

    # -------------------------
    # STEP 10: Verify Nginx Pod
    # -------------------------
    - name: Verify Nginx Pod
      run: kubectl get pods

    # -------------------------
    # STEP 11: Terraform Destroy (Cleanup)
    # -------------------------
    - name: Terraform Destroy
      if: always()
      run: terraform destroy -auto-approve
