
![EJBCA](.github/ejbca-by-keyfactor_small.png)

# Helm Chart for EJBCA Community [![Discuss](https://img.shields.io/badge/discuss-ejbca-ce?style=flat)](https://github.com/Keyfactor/ejbca-ce/discussions) ![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 7.9.0](https://img.shields.io/badge/AppVersion-7.9.0-informational?style=flat-square)

EJBCA covers all your needs – from certificate management, registration and enrollment to certificate validation.

Welcome to EJBCA – the Open Source Certificate Authority (software). EJBCA is one of the longest running CA software projects, providing time-proven robustness, reliability and flexibitlity. EJBCA is platform independent and can easily be scaled out to match the needs of your PKI requirements, whether you’re setting up a national eID, securing your industrial IoT platform or managing your own internal PKI for Enterprise or DevOps.

EJBCA is developed in Java and runs on a JVM such as OpenJDK, available on most platforms such as Linux and Windows.

There are two versions of EJBCA:
* **EJBCA Community** (EJBCA CE) - free and open source, OSI Certified Open Source Software
* **EJBCA Enterprise** (EJBCA EE) - commercial and Common Criteria certified

OSI Certified is a certification mark of the Open Source Initiative.

## Prerequisites

- [Kubernetes](http://kubernetes.io) v1.19+
- [Helm](https://helm.sh) v3+

## Getting started

The **EJBCA Community Helm Chart** boostraps **EJBCA Community** on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

### Add repo
```shell
helm repo add https://github.com/Keyfactor/ejbca-ce-helm
helm repo update
```

### Quick start
```shell
helm upgrade --install ejbca-ce ejbca-ce \
  --repo https://github.com/Keyfactor/ejbca-ce-helm \
  --namespace ejbca --create-namespace
```
This command deploys `ejbca-ce-helm` on the Kubernetes cluster in the default configuration. To customize the installation,
see [helm install](https://helm.sh/docs/helm/helm_install/) for command documentation.

_See [configuration](#configuration) below to customize deployment._

### Uninstall chart
```shell
helm uninstall [RELEASE_NAME]
```
This command removes all Kubernetes components associated with this chart and deletes the release.

_See [helm uninstall](https://helm.sh/docs/helm/helm_uninstall/) for command documentation._

## Community Support

In our Community we welcome contributions. The Community software is open source and community supported, there is no support SLA, but a helpful best-effort Community.

* To report a problem or suggest a new feature, use the **[Issues](../../issues)** tab.
* If you want to contribute actual bug fixes or proposed enhancements, use the **[Pull requests](../../pulls)** tab.
* Ask the community for ideas: **[EJBCA Discussions](https://github.com/Keyfactor/ejbca-ce/discussions)**.
* Read more in our documentation: **[EJBCA Documentation](https://doc.primekey.com/ejbca)**.
* See release information: **[EJBCA Release information](https://doc.primekey.com/ejbca/ejbca-release-information)**.
* Read more on the open source project website: **[EJBCA website](https://www.ejbca.org/)**.

## Commercial Support
Commercial support is available for **[EJBCA Enterprise](https://www.keyfactor.com/platform/keyfactor-ejbca-enterprise/)**.

## License
EJBCA Community is licensed under the LGPL license, please see **[LICENSE](LICENSE)**.

## Configuration


## Values

| Key                                       | Type   | Default                                                                                              | Description                                                                                                                                                                    |
|-------------------------------------------|--------|------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ejbca.enabled                             | bool   | `true`                                                                                               | Enables EJBCA deployment                                                                                                                                                       |
| ejbca.eeConfig.initialAdmin               | string | `ManagementCA;WITH_COMMONNAME;SuperAdmin`                                                            | Configures initial admin role and rules for EJBCA. Default value requires that a certificate signed by ManagementCA with CN SuperAdmin be passed to EJBCA when authenticating. |
| ejbca.eeConfig.adminWebAccess             | string | `true`                                                                                               | Enables EJBCA /adminweb/ access                                                                                                                                                |
| ejbca.reverseProxy.image.repository       | string | `httpd`                                                                                              | Repository to get EJBCA reverse proxy. Default is Apache httpd                                                                                                                 |
| ejbca.reverseProxy.image.pullPolicy       | string | `"IfNotPresent`                                                                                      | Image pull policy                                                                                                                                                              |
| ejbca.reverseProxy.image.tag              | string | `2.4`                                                                                                | Reverse proxy image pull tag                                                                                                                                                   |
| ejbca.caFinderImage.image.repository      | string | `m8rmclarenkf/ejbca-management-ca-locator`                                                           | Repository for CA image finder deployed as init container. Certificate found by this container is used for client certificate authentication by reverse proxy                  |
| ejbca.caFinderImage.image.pullPolicy      | string | `IfNotPresent`                                                                                       | Image pull policy                                                                                                                                                              |
| ejbca.caFinderImage.image.tag             | string | `1.0.0`                                                                                              | Reverse proxy image pull tag                                                                                                                                                   |
| ejbca.logShipper.enabled                  | string | `false`                                                                                              | Enables or disables the deployment of a compatible log shipper. By default, fluent-bit is deployed if this is true.                                                            |
| ejbca.logShipper.configMapName            | string | `fluent-bit-conf`                                                                                    | Configmap name used to configure log shipper. This configmap is mounted to the log shipper container.                                                                          |
| ejbca.logShipper.logLevel                 | string | `INFO`                                                                                               | Log level EJBCA should store in log shipper directory                                                                                                                          |
| ejbca.logShipper.logPath                  | string | `/opt/log`                                                                                           | Directory EJBCA will store logs in for pickup by log shipper                                                                                                                   |
| ejbca.logShipper.maxStorageSize           | string | `256`                                                                                                | Maximum size of log directory in MB                                                                                                                                            |
| ejbca.logShipper.image.repository         | string | `fluent/fluent-bit`                                                                                  | Log shipper container repository                                                                                                                                               |
| ejbca.logShipper.image.tag                | string | `latest`                                                                                             | Log shipper container version                                                                                                                                                  |
| ejbca.logShipper.image.pullPolicy         | string | `IfNotPresent`                                                                                       | Log shipper container pull policy                                                                                                                                              |
| ejbca.logShipper.ports                    | list   | `[{"name":"http","containerPort":80,"protocol":"TCP"}]`                                              | List of objects that configure the ports that the log shipper container and service should expose                                                                              |
| ejbca.ui.enabled                          | bool   | `true`                                                                                               | Enables creation of service and ingress objects for access to EJBCA UI endpoints                                                                                               |
| ejbca.ui.name                             | string | `"ejbca-ui"`                                                                                         | Name of K8s service created for UI access                                                                                                                                      |
| ejbca.ui.host                             | string | `""`                                                                                                 | Ingress host                                                                                                                                                                   |
| ejbca.ui.ingressClassName                 | string | `"nginx"`                                                                                            | Ingress classname for K8s ingress controller                                                                                                                                   |
| ejbca.ui.ingressAnnotations               | list   | `[]`                                                                                                 | Annotations to attach to UI ingress object                                                                                                                                     |
| ejbca.ui.ports                            | list   | `[{"name":"https","port":8443,"paths":[]}]`                                                          | List of ports and associated configuration used to configure UI service and ingress objects                                                                                    |
| ejbca.ui.ports[n].paths                   | list   | `[{"path":"/ejbca","pathType":"Prefix"}]`                                                            | List of paths exposed by ingress object                                                                                                                                        |
| ejbca.rr.enabled                          | bool   | `true`                                                                                               | Enables creation of service and ingress objects for access to EJBCA programmatic resources                                                                                     |
| ejbca.rr.name                             | string | `"ejbca-rr"`                                                                                         | Name of K8s service created for programmatic access                                                                                                                            |
| ejbca.rr.host                             | string | `""`                                                                                                 | Ingress host                                                                                                                                                                   |
| ejbca.rr.ingressClassName                 | string | `"nginx"`                                                                                            | Ingress classname for K8s ingress controller                                                                                                                                   |
| ejbca.rr.ingressAnnotations               | list   | `[]`                                                                                                 | Annotations to attach to programmatic ingress object                                                                                                                           |
| ejbca.rr.ports                            | list   | `[{"name":"https","port":443,"paths":[]}]`                                                           | List of ports and associated configuration used to configure programmatic service and ingress objects                                                                          |
| ejbca.rr.ports[n].paths                   | list   | `[{"path":"/.well-known","pathType":"Prefix"},{"path":"/ejbca/ejbca-rest-api","pathType":"Prefix"}]` | List of paths exposed by ingress object                                                                                                                                        |
| ejbca.lb.enabled                          | bool   | `true`                                                                                               | Enables creation of NodePort service                                                                                                                                           |
| ejbca.lb.name                             | string | `"ejbca-lb"`                                                                                         | Name of K8s service created for programmatic access                                                                                                                            |
| ejbca.lb.ports                            | list   | `[{"name":"https","port":443,"nodePort":32713}]`                                                     | List of ports and associated configuration for the load balancer NodePort service                                                                                              |
| database.localDeployment.deployDatabase   | bool   | `false`                                                                                              | Boolean that configures chart to deploy local database for connection to EJBCA                                                                                                 |
| database.localDeployment.username         | string | `"ejbca"`                                                                                            | Database username                                                                                                                                                              |
| database.localDeployment.password         | string | `"ejbca"`                                                                                            | Database password                                                                                                                                                              |
| database.localDeployment.passwordRoot     | string | `"foo123"`                                                                                           | Database root password                                                                                                                                                         |
| database.localDeployment.image.repository | string | `"mariadb"`                                                                                          | Repository to find database container                                                                                                                                          |
| database.localDeployment.image.pullPolicy | string | `IfNotPresent`                                                                                       | Image pull policy                                                                                                                                                              |
| database.localDeployment.image.tag        | string | `"10.5"`                                                                                             | Database proxy image pull tag                                                                                                                                                  ||                                           |        |                                                                                                      |                                                                                                                                                                                |
| database.host                             | string | `"database-svc"`                                                                                     | Hostname of database to connect to.                                                                                                                                            |
| database.port                             | string | `3306`                                                                                               | Database port                                                                                                                                                                  |
| database.secretName                       | string | `"ejbca-database-credentials"`                                                                       | Secret name containing credentials to database                                                                                                                                 |
|                                           |        |                                                                                                      |                                                                                                                                                                                |
|                                           |        |                                                                                                      |                                                                                                                                                                                |


## Related projects

* [Keyfactor/ansible-ejbca-signserver-playbooks](https://github.com/Keyfactor/ansible-ejbca-signserver-playbooks)
* [Keyfactor/ejbca-tools](https://github.com/Keyfactor/ejbca-tools)
* [Keyfactor/ejbca-vault-plugin](https://github.com/Keyfactor/ejbca-vault-plugin)
* [Keyfactor/ejbca-vault-monitor](https://github.com/Keyfactor/ejbca-vault-monitor)
* [Keyfactor/ejbca-cert-cvc](https://github.com/Keyfactor/ejbca-cert-cvc)
* [Keyfactor/ejbca-containers](https://github.com/Keyfactor/ejbca-containers) 
