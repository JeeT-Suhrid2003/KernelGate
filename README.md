# KernelGate 🚀
### eBPF-Driven Canary Performance Analysis

**KernelGate** is a cloud-native reliability guardrail designed to detect resource-inefficient code before it reaches production. By leveraging **eBPF (Extended Berkeley Packet Filter)** via **Inspektor Gadget**, it audits container behavior at the Linux Kernel level during the Canary deployment phase.

---

## 📌 Overview
Traditional CI/CD pipelines verify if code *works* (functional testing), but they often ignore if code is *expensive* or *unstable* (performance testing). KernelGate solves the "Blind Spot" problem: code that passes unit tests but contains hidden memory leaks or CPU spikes.

### Key Features
* **Kernel-Level Observability:** Monitors syscalls and CPU cycles without application instrumentation.
* **Automated Canary Gate:** Profiles new deployments against a baseline and rejects "wasteful" code.
* **Self-Healing:** Automatically triggers `kubectl rollout undo` upon detecting performance anomalies.
* **Zero-Trust Reliability:** Prevents "noisy neighbor" scenarios by enforcing strict resource-efficiency standards.

---

## 🛠️ Architecture
1.  **Deployment:** A new version is deployed to the `canary-lab` namespace.
2.  **Observation:** An automated gatekeeper initiates an OCI-based eBPF gadget (`top_process`).
3.  **Stress Test:** Synthetic traffic is routed to the `/chaos` endpoint to simulate load.
4.  **Analysis:** The gatekeeper compares real-time kernel metrics against a defined threshold (e.g., >40% CPU).
5.  **Decision:** The gatekeeper either promotes the deployment or executes an immediate rollback.

[Image of eBPF-based performance gate workflow in Kubernetes]

---

## 🚀 Getting Started

### Prerequisites
* [Kind](https://kind.sigs.k8s.io/) (Kubernetes in Docker)
* [Inspektor Gadget](https://inspektor-gadget.io/)
* Docker & Python 3.x

### 1. Build and Load the Image
```bash
# Build the custom Chaos API
docker build -t my-chaos-api:v1 .

# Load image into the Kind cluster
kind load docker-image my-chaos-api:v1 --name perf-gate-lab


## And yes the code mostly was written by AI(gemini), and "It Works"( took me 1 day to actually do the whole setup and run)
