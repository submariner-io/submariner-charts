# submariner-charts

Please see the [Helm docs on Submariner's website](https://submariner.io/operations/deployment/helm/).

## Development workflow

### Prerequisites

- [Helm] v3
- [Docker] or [Podman]

### Create a fork and checkout

[Create a fork] of the original repository, clone it locally and checkout a new branch from master.

Example:

```bash
git clone https://github.com/myuser/submariner-charts.git
cd submariner-charts
git checkout -b new-feature
```

Now you can modify the Helm charts according to your needs.

### Use the modified charts

Locally-modified charts can be installed using `helm install`,
referring to the local path; for example:

```bash
helm install submariner-k8s-broker ./submariner-k8s-broker ...
```

In the base directory of this repository, a local deployment using the
local charts can be obtained by running the following command:

```bash
make deploy
```

This will start two kind clusters and deploy Submariner using the
Broker and Operator charts.

```bash
make e2e
```

will run the end-to-end test suite used to validate that Submariner is
working correctly.

<!--links-->
[Helm]: https://helm.sh/docs/using_helm/#installing-helm
[Docker]: https://docs.docker.com/install/
[Podman]: https://podman.io/getting-started/installation
[Create a fork]: https://help.github.com/en/articles/fork-a-repo
