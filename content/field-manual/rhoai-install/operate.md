---
title: Operate
description: Day-two routine checks — operator health, component status, upgrade drift, escalation.
weight: 20
icon: fa-solid fa-gauge-high
---

What an operator does on a normal day: confirm the operator and the DataScienceCluster are healthy, watch for upgrade drift, and know when to escalate.

{{< variant version 3.4 >}}
On **3.4**, the operator deployment is `rhods-operator` and the dashboard namespace is `redhat-ods-applications` — same as 3.5+; no endpoint change.
{{< /variant >}}

{{< variant version "3.5 3.6" >}}
On **3.5 and 3.6**, same deployment and namespace as 3.4; component names in the DSC (`dashboard`, `workbenches`, `datasciencepipelines`) match the CRD fields.
{{< /variant >}}

## Procedure

1. Check operator health:

```sh
oc get deployment rhods-operator -n redhat-ods-operator -o jsonpath='{.status.conditions[?(@.type=="Available")].status}'
```

Expected output:

```sh
True
```

2. Check DataScienceCluster conditions:

```sh
oc get datasciencecluster default-dsc -o jsonpath='{.status.conditions}'
```

Expected output includes `"type":"Ready","status":"True"` and no entry with `"status":"True"` for `Degraded`.

3. Check for stuck installs:

```sh
oc get pods -n redhat-ods-operator
```

Expected output: `rhods-operator-<hash>` with `1/1` (or `2/2`) `Running` and restarts not climbing between checks.

4. Check for upgrade drift — the installed channel vs the subscription's target:

```sh
oc get subscription rhods-operator -n redhat-ods-operator -o jsonpath='{.spec.channel}{" -> "}{.status.installedCSV}'
```

Expected output: the channel you installed from (e.g. `fast`) followed by the CSV currently installed (e.g. `rhods-operator.v2.20.0`) — a channel bump with no CSV change means the upgrade is stuck; go to [Things that broke](things-that-broke/).

5. If anything above reports unhealthy or stuck, go to [Things that broke]({{< relref "things-that-broke" >}}).

> [!TIP]
> The selector at the top filters this manual: pick GitOps, Manual, or Scripted, and 3.4, 3.5, or 3.6 — the choice persists across pages and visits.

Escalation criteria and the verify-command rule: [Conventions and intent]({{< relref "/writing-the-field-manual/conventions" >}}).
