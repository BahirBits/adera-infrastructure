# install  helm on mac
brew install helm
# update helm and add bitinami repo
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
# crate namespace
create namespace aderadb
# deploy postgres
# Create a Kubernetes secret to securely store the PostgreSQL password
kubectl create secret generic postgres-password --from-literal=password="bahirbits2024" --namespace aderadb
# Install PostgreSQL with the updated values.yaml
kubectl apply -f override-postgres-pvc.yaml -n aderadb
helm install postgres bitnami/postgresql -f postgres-values.yaml --namespace aderadb

# to deploy redis 
kubectl create secret generic redis-password --from-literal=password="bahirbits2024" --namespace aderadb
kubectl apply -f override-redis-pvc.yaml -n aderadb 
helm install redis bitnami/redis -f redis-values.yaml --namespace aderadb

# patched later to have username as a key
kubectl create secret generic postgres-postgresql \
  --from-literal=username=postgres \
  --from-literal=postgres-password=$(kubectl get secret postgres-postgresql -n aderadb -o jsonpath='{.data.postgres-password}' | base64 --decode) \
  -n aderadb --dry-run=client -o yaml | kubectl apply -f -

#patch 
helm upgrade redis bitnami/redis -f redis-values.yaml -n aderadb
