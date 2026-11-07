---
title: Things that broke
description: Known issues, where the reader hits them — symptom, diagnosis, workaround.
weight: 30
icon: fa-solid fa-triangle-exclamation
---

Known issues live in the page where the reader hits them — the install steps live in [Set up](set-up/), the day-two checks in [Operate](operate/); the entries below cover the breakage hit from either page.

## Known issue: DataScienceCluster stuck Degraded after install

**Symptom.** `oc wait --for=condition=Ready datasciencecluster/default-dsc` times out; the DSC reports `Degraded`.

**Diagnosis.**

```sh
oc get datasciencecluster default-dsc -o jsonpath='{.status.conditions}' | tr ',' '\n' | grep -A1 Degraded
oc get pods -n redhat-ods-applications
```

Expected finding: one component's pod in `CreateContainerError` or `ImagePullBackOff`, and a matching message in the DSC status.

**Workaround.** Fix the failing component first (usually a missing `ImageSetConfiguration` mirror or a pinned-image mismatch), then delete the failing pod so it re-deploys:

```sh
oc delete pod <failing-pod> -n redhat-ods-applications
```

Expected output:

```sh
pod "<failing-pod>" deleted
```

The operator recreates it and the DSC converges back to Ready.

**Tracker.** RHOAIENG-0000 (placeholder — real issues carry their Jira/KCS id here).

## Known issue: operator CSV stuck InstallWaiting after channel bump

**Symptom.** The subscription's `installedCSV` stays behind after a channel change; `oc get csv` shows the new CSV in `InstallWaiting`.

**Diagnosis.**

```sh
oc get subscription rhods-operator -n redhat-ods-operator -o jsonpath='{.status.installedCSV}'
oc get csv -n redhat-ods-operator | grep -v Succeeded
```

Expected finding: the target CSV present but not `Succeeded`.

**Workaround.** Delete the operator's install plan so OLM re-resolves it:

```sh
oc delete installplan -n redhat-ods-operator --all
```

Expected output: one `installplan.operators.coreos.com "<name>" deleted` line per plan. The operator re-installs and `installedCSV` catches up within a few minutes.

**Tracker.** RHOAIENG-0000 (placeholder — real issues carry their Jira/KCS id here).

## Known issue: dashboard route 503 right after install

**Symptom.** The dashboard URL returns 503 immediately after the DSC reports Ready.

**Diagnosis.**

```sh
oc get pods -n redhat-ods-applications -l app=kubeflow-dashboard
oc describe pod -l app=kubeflow-dashboard -n redhat-ods-applications | grep -A3 "Last State"
```

Expected finding: the dashboard pod still `Running` with an old `Ready` count, or restarting.

**Workaround.** Wait for the dashboard deployment to finish rolling out, then retry:

```sh
oc rollout status deployment/odh-dashboard -n redhat-ods-applications
```

Expected output:

```sh
deployment "odh-dashboard" successfully rolled out
```

**Tracker.** RHOAIENG-0000 (placeholder — real issues carry their Jira/KCS id here).

> [!TIP]
> The anatomy each known issue must carry is codified in [Conventions and intent]({{< relref "/writing-the-field-manual/conventions" >}}).
