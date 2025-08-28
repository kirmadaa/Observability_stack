# Grafana Observability Stack

This Helm chart deploys a complete Grafana observability stack to your Kubernetes cluster. It is designed to be a minimal, working setup for a Proof of Concept (POC), but includes commented-out configurations to easily transition to a production-ready environment.

## Components

This umbrella chart includes the following components:

- **Grafana:** For visualization, dashboards, and exploring data.
- **Prometheus:** For metrics collection and storage.
- **Loki:** For log aggregation.
- **Tempo:** For distributed tracing.
- **Pyroscope:** For continuous profiling.
- **Grafana Alloy:** As a unified agent to collect and forward all telemetry data.

## Prerequisites

- A running Kubernetes cluster.
- [Helm](https://helm.sh/docs/intro/install/) installed on your client machine.

## Installation

1.  **Add the required Helm repositories:**

    ```bash
    helm repo add grafana https://grafana.github.io/helm-charts
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    helm repo update
    ```

2.  **Build the Chart Dependencies:**

    Before installing, you need to fetch the chart's dependencies.

    ```bash
    helm dependency build ./grafana-observability-stack
    ```

3.  **Install the chart:**

    You can deploy the chart with the following command. Replace `<release-name>` with a name for your deployment (e.g., `my-obs-stack`).

    ```bash
    helm install <release-name> ./grafana-observability-stack -n <namespace> --create-namespace
    ```

    For example:

    ```bash
    helm install my-obs-stack ./grafana-observability-stack -n monitoring --create-namespace
    ```

## Accessing Grafana

By default, this chart exposes Grafana using a `NodePort`. To access the Grafana UI:

1.  **Get the Grafana service details:**

    ```bash
    kubectl get svc -n <namespace> <release-name>-grafana
    ```

2.  Find the `NodePort` value (e.g., `3000:32145/TCP`, where `32145` is the NodePort).

3.  Access Grafana in your browser at `http://<your-node-ip>:<node-port>`.

4.  The default credentials are:
    -   **Username:** `admin`
    -   **Password:** `admin` (as configured in `values.yaml`)

## Production Configuration

The default `values.yaml` is configured for a POC. For a production environment, you should consider the following:

### Enable Ingress for Grafana

To expose Grafana via an Ingress controller:

1.  Open `values.yaml`.
2.  Under the `grafana` section, enable the `ingress` block and configure your hostname:

    ```yaml
    grafana:
      ingress:
        enabled: true
        ingressClassName: nginx # Or your ingress controller
        hosts:
          - grafana.your-domain.com
        tls:
          - secretName: grafana-tls # Your TLS secret
            hosts:
              - grafana.your-domain.com
    ```

3.  Upgrade your Helm release:

    ```bash
    helm upgrade <release-name> . -n <namespace>
    ```

### Enable Persistence

To enable persistent storage for Grafana, Prometheus, Loki, and Tempo:

1.  Open `values.yaml`.
2.  For each component (`grafana`, `prometheus`, `loki`, `tempo`), find the `persistence` section and set `enabled: true`.
3.  Specify a `storageClassName` that is available in your cluster.

    Example for Grafana:
    ```yaml
    grafana:
      persistence:
        enabled: true
        storageClassName: "your-storage-class"
        size: 10Gi
    ```

4.  Upgrade your Helm release.
