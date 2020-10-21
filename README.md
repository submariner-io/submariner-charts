# submariner-charts

Please see the [Helm docs on Submariner's website](https://submariner.io/deployment/helm/).

## Dev workflow

### Prerequisites

- [helm]
- [docker] or [podman]

### Create a fork and checkout

[Create a fork] of the original repository, clone it locally and checkout a new branch from master.

Example:

```bash
git clone https://github.com/myuser/submariner-charts.git
cd submariner-charts
git checkout -b new-feature
```

Now you can modify the helm charts according to your needs.

### Serve the modified charts

Before serving the modified charts, the charts must be packaged for local usage.

```bash
helm package ./submariner
helm package ./submariner-k8s-broker
```

Note: if you just installed helm, you have to init the helm, by running

```bash
helm init --client-only
```

Serve the packaged charts through a local helm repository:

```bash
docker run -d --rm --name helm-repo -p 8080:8080 -v $PWD:/charts -e DEBUG=true -e STORAGE=local -e STORAGE_LOCAL_ROOTDIR=/charts chartmuseum/chartmuseum
```

or

```bash
sudo podman run -d --rm --name helm-repo -p 8080:8080 -v $PWD:/charts -e DEBUG=true -e STORAGE=local -e STORAGE_LOCAL_ROOTDIR=/charts chartmuseum/chartmuseum
```

Get the container internal ip:

```bash
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' helm-repo
```

The local container will serve the charts locally on port 8080.

Get logs for the container:

```bash
docker logs -f helm-repo
```

### Use the modified charts

Init helm

```bash
helm init --client-only
```

Add your local repository to helm

```bash
internal_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' helm-repo)
helm repo add test-repo http://$internal_ip:8080
```

List the repos:

```bash
helm repo list
```

You should be able to see test-repo in the list

Search the new repo for submariner charts:

```bash
helm search -l test-repo
```

### Modify submariner e2e tests helm deployment script to use your local test-repo

You can test your helm-charts with e2e tests from the [shipyard](https://github.com/submariner-io/shipyard) repository.
In the file `scripts/shared/lib/deploy_helm` change the line from:

```bash
helm repo add submariner-latest https://submariner-io.github.io/submariner-charts/charts
```

to

```bash
internal_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' helm-repo)
helm repo add submariner-latest http://$internal_ip:8080
```

<!--links-->
[helm]: https://helm.sh/docs/using_helm/#installing-helm
[docker]: https://docs.docker.com/install/
[podman]: https://podman.io/getting-started/installation
[Create a fork]: https://help.github.com/en/articles/fork-a-repo
