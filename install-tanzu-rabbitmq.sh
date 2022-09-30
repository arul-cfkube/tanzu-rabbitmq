#tmc cluster create  -n=tanzu-demo  -c=arul-tmc-pa -s=tmc-ssh-key  -y=c5.2xlarge -g=akv-tmc -q=3
# sleep 600
# #while [[ $(tmc cluster get tanzu-demo -o json | jq -r .status.phase) == "READY" ]]; do tmc cluster get tanzu-demo -o json | jq  -r .status.phase; sleep 5 ; done
# tmc cluster auth kubeconfig get tanzu-demo > ~/.kube/config
#tanzu package install cert-manager --package-name cert-manager.tanzu.vmware.com --namespace cert-manager  --version 1.7.2+vmware.1-tkg.1  --create-namespace
kubeclt apply cert-manger-package.yml
tanzu package installed update cert-manager --package-name cert-manager.tanzu.vmware.com --namespace cert-manager  --version 1.7.2+vmware.1-tkg.1  -f cert-manger-package.yml

#Open Source carvel
# sleep 60
#kapp deploy -a kc -f https://github.com/vmware-tanzu/carvel-kapp-controller/releases/latest/download/release.yml
#kapp deploy -a sg -f https://github.com/vmware-tanzu/carvel-secretgen-controller/releases/latest/download/release.yml
#kapp deploy -a cert-manger -f https://github.com/cert-manager/cert-manager/releases/download/v1.7.2/cert-manager.yaml

#Contour for ingress (optional)
#tanzu package install contour --package-name contour.tanzu.vmware.com --version 1.20.2+vmware.1-tkg.1 --create-namespace
#kapp deploy -a cert-manager-rabbitmq -f cert-manger-package.yml -y
kubectl create ns secrets-ns

# kubectl apply -f cert-overlay.yaml
# kubectl apply -f resource-overlay.yaml
kubectl create sa rabbitmq-operator
kubectl apply -f cluster-role-rabbitmq.yml
kubectl  create clusterrolebinding rmq-cluster-binding  --clusterrole=tanzu-rabbitmq-crd-install --serviceaccount=default:rabbitmq-operator
kubectl apply -f reg-creds.yml
kubectl apply -f secret-export.yml
kapp deploy -a tanzu-rabbitmq-repo -f package.yml -y
kubectl get packages | grep rabbit
#kubectl -n rabbitmq-system create secret generic rabbitmq-ca --from-file=ca.crt=./rabbitmq-hare.pem
#kubectl -n rabbitmq-system create secret generic rabbitmq-ca --from-file=ca.crt=/Users/avannala/Documents/workspace/rabbitmq/config/live/rabbitmq.arullab.com/fullchain.pem
kapp deploy -a tanzu-rabbitmq -f packageinstall.yml -y

# kubectl apply -f tanzu-rabbitmq-registry-creds.yml
# kapp deploy -a rmq-cluster -f rmq.yml -y
# sleep  60
# kubectl exec tanzu-rabbit-demo-2-server-0 -- rabbitmqctl add_user arul pas234Uo12
# kubectl exec tanzu-rabbit-demo-2-server-0 -- rabbitmqctl set_permissions  -p / arul ".*" ".*" ".*"
# kubectl exec tanzu-rabbit-demo-2-server-0 -- rabbitmqctl set_user_tags arul administrator
# kubectl apply -f tanzu-rabbitmq-replication.yaml
# kubectl exec tanzu-hare-server-0 -- rabbitmq-diagnostics resolve_hostname hare.gke.arullab.com --address-family 34.172.66.96 --offline
# #
user: app password: CHANGEME

kubectl exec tanzu-bunny-server-0 -- rabbitmqctl add_user arul pas234Uo12
kubectl exec tanzu-bunny-server-0 -- rabbitmqctl set_permissions  -p / arul ".*" ".*" ".*"
kubectl exec tanzu-bunny-server-0 -- rabbitmqctl set_user_tags arul administrator
#
kubectl exec tanzu-hare-server-0 -- rabbitmqctl add_user arul pas234Uo12
kubectl exec tanzu-hare-server-0 -- rabbitmqctl set_permissions  -p / arul ".*" ".*" ".*"
kubectl exec tanzu-hare-server-0 -- rabbitmqctl set_user_tags arul administrator

kubectl exec tanzu-hare-server-0 -- rabbitmqctl add_user app  CHANGEME
kubectl exec tanzu-hare-server-0 -- rabbitmqctl set_permissions  -p / app ".*" ".*" ".*"
kubectl exec tanzu-hare-server-0 -- rabbitmqctl set_user_tags app administrator
#
# kubectl exec tanzu-hare-server-0 -- rabbitmqctl add_vhost rabbitmq_schema_definition_sync
#
# # Create a user and grant it permissions to the virtual host that will be
# # used for schema replication.
# # This command is similar to 'rabbitmqctl add_user' but also grants full permissions
# # to the virtual host used for definition sync.
# kubectl exec tanzu-hare-server-0 --  rabbitmqctl add_schema_replication_user "schema-replicator" "$3kRe7"
#
# # specify local (upstream cluster) nodes and credentials to be used
# # for schema replication
# rabbitmqctl set_schema_replication_upstream_endpoints '{"endpoints": ["a.rabbitmq.eu-1.local:5672","b.rabbitmq.eu-1.local:5672","c.rabbitmq.eu-1.local:5672"], "username": "schema-replicator", "password": "$3kRe7"}'
