---
title: Set up
description: Install the RHOAI operators on the cluster — prerequisites, procedure, verification, rollback.
weight: 10
icon: fa-solid fa-play
---

Install Red Hat OpenShift AI on the cluster. Outcome: the `redhat-ods-operator` subscription is Healthy and the OpenShift AI dashboard route resolves. This page covers prerequisites, the operator install, and verification; day-two checks live in [Operate](operate/), breakage in [Things that broke](things-that-broke/).

{{< variant mode all >}}
This manual's steps work the same in every ops mode — GitOps, Manual, and Scripted; the blocks below call out where they differ.
{{< /variant >}}

## Prerequisites

- OpenShift cluster 4.14+ with cluster-admin access.
- `oc` matching the cluster version.
- Your cluster's API endpoint, e.g. `api{{< customize cluster >}}`, and a username (default: {{< customize user >}}).
- OpenShift AI version to install — see the version selector at the top of this page.

## Procedure

1. Log in to the cluster:

```sh
oc login --username={{< customize user >}} --server=api{{< customize cluster >}}
```

Expected output ends with:

```sh
Login successful.
```

2. Create the `redhat-ods-operator` namespace:

```sh
oc create namespace redhat-ods-operator
```

Expected output:

```sh
namespace/redhat-ods-operator created
```

3. Install the OpenShift AI Operator.

{{< variant mode gitops >}}
Apply via GitOps (manifests under `manifests/rhoai-install/`):

```sh
oc apply -k manifests/rhoai-install/
```

Expected output: `namespace/redhat-ods-operator unchanged`, `operatorgroup.rhoai-operator... created` (or `unchanged` on re-runs), and `subscription.rhods-operator created` (or `unchanged`).
{{< /variant >}}

{{< variant mode manual >}}
Apply from the web console: **Ecosystem → OperatorHub → Red Hat OpenShift AI** (filter by keyword "OpenShift AI") → **Install** → channel `fast`, approval **Automatic** → **Install**.
{{< /variant >}}

{{< variant mode scripted >}}
Apply with the deployment script (idempotent — safe to re-run):

```sh
./scripts/apply-rhoai.sh
```

Expected output ends with `subscription.rhods-operator configured`.
{{< /variant >}}

4. Verify the operator subscription is Healthy (all modes):

```sh
oc get subscription rhods-operator -n redhat-ods-operator -o jsonpath='{.status.state}'
```

Expected output:

```sh
AtLatestKnown
```

5. Wait for the operator to deploy:

```sh
oc wait --for=condition=Available deployment/rhods-operator -n redhat-ods-operator --timeout=300s
```

Expected output:

```sh
deployment.apps/rhods-operator condition met
```

{{< variant version "3.5 3.6" >}}
On **3.5 and 3.6**, the DataScienceCluster `default` in step 6 installs all core components; leave `spec.components` at defaults.
{{< /variant >}}

{{< variant version 3.4 >}}
On **3.4**, the DataScienceCluster also defaults all components; if the operator image was pulled before 2024-11, check `spec.components.dashboard` exists — early 3.4 builds dropped it from the CRD sample.
{{< /variant >}}

6. Create the DataScienceCluster (the operator installs the components it manages):

```sh
oc apply -f - <<'EOF'
apiVersion: datasciencecluster.opendatahub.io/v1
kind: DataScienceCluster
metadata:
  name: default-dsc
spec:
  components: {}
EOF
```

Expected output:

```sh
datasciencecluster.datasciencecluster.opendatahub.io/default-dsc created
```

## Verification

Confirm the DataScienceCluster reports Ready and the dashboard route resolves:

```sh
oc wait --for=condition=Ready datasciencecluster/default-dsc --timeout=600s
```

Expected output:

```sh
datasciencecluster.datasciencecluster.opendatahub.io/default-dsc condition met
```

```sh
oc get route rhods-dashboard -n redhat-ods-applications -o jsonpath='{.spec.host}'
```

Expected output: a hostname ending in your cluster domain, e.g. `rhods-dashboard-redhat-ods-applications.apps{{< customize cluster >}}`.

## Rollback

{{< variant mode gitops >}}
Revert the manifest commit under `manifests/rhoai-install/`; the cluster converges back.
{{< /variant >}}

{{< variant mode manual >}}
**Ecosystem → Installed Operators → Red Hat OpenShift AI → three-dot menu → Uninstall Operator**, then delete the `redhat-ods-operator` and `redhat-ods-applications` namespaces.
{{< /variant >}}

{{< variant mode scripted >}}
Run the rollback script:

```sh
./scripts/rollback-rhoai.sh
```

Expected output ends with `datasciencecluster.datasciencecluster.opendatahub.io "default-dsc" deleted`.
{{< /variant >}}

> [!WARNING]
> Rollback mid-flight leaves the DSC components half-provisioned — re-run the procedure from step 1 after rollback, and see the DSC stuck-degrading issue in [Things that broke]({{< relref "things-that-broke" >}}).

Why this shape? See [Conventions and intent]({{< relref "/writing-the-field-manual/conventions" >}}).
