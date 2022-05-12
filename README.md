# submariner-charts

<!-- markdownlint-disable line-length -->
[![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/4865/badge)](https://bestpractices.coreinfrastructure.org/projects/4865)
[![Release Charts](https://github.com/submariner-io/submariner-charts/workflows/Release%20Charts/badge.svg)](https://github.com/submariner-io/submariner-charts/actions?query=workflow%3A%22Release+Charts%22)
[![Periodic](https://github.com/submariner-io/submariner-charts/workflows/Periodic/badge.svg)](https://github.com/submariner-io/submariner-charts/actions?query=workflow%3APeriodic)
[![Flake Finder](https://github.com/submariner-io/submariner-charts/workflows/Flake%20Finder/badge.svg)](https://github.com/submariner-io/submariner-charts/actions?query=workflow%3A%22Flake+Finder%22)
<!-- markdownlint-enable line-length -->

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
[Create a fork]: https://docs.github.com/en/get-started/quickstart/fork-a-repo
