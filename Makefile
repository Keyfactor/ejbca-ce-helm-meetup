NAMESPACE=ejbca
POD_NAME=ejbca-ce
CHART_NAME=ejbca-ce-1.0.0.tgz

DOCKER_USERNAME=m8rmclarenkf
CERT_LOCATOR_CONTAINER_NAME=ejbca-management-ca-locator
CERT_LOCATOR_VERSION=1.0.0

clean:
	helm uninstall -n $(NAMESPACE) $(POD_NAME) || (echo nothing to clean)

helm: clean
	helm package charts/ejbca-ce
	helm install -n $(NAMESPACE) $(POD_NAME) -f charts/ejbca-ce/values.yaml $(CHART_NAME) --debug

pods:
	kubectl -n $(NAMESPACE) get pods

logs:
	kubectl -n $(NAMESPACE) logs $(shell kubectl get pods --template '{{range .items}}{{.metadata.name}}{{end}}' -n $(NAMESPACE))

docker:
	docker build -t $(DOCKER_USERNAME)/$(CERT_LOCATOR_CONTAINER_NAME):$(CERT_LOCATOR_VERSION) .
	docker login
	docker push $(DOCKER_USERNAME)/$(CERT_LOCATOR_CONTAINER_NAME):$(CERT_LOCATOR_VERSION)