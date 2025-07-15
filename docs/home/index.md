# &lt;osp⚡&gt; Object Storage Proxy

A fast and safe in-process gateway for AWS S3 and compatible services (IBM Cloud Object Storage, Minio, ...).

*⎯ Speed, Security, Simplicity. Pick three. ⎯*

## What &lt;osp⚡&gt; Does & Why It Matters

### 🚀 Instant, Identity-Aware Access to Any Bucket  
Drop this proxy in front of S3, GCS, IBM COS, Azure Blob, MinIO, or Ceph. It accepts whatever your users already have—OIDC, SAML, JWT, mTLS—then transparently signs and routes the request to the right backend. No hard-coded keys, no presigned URLs, no code changes.

### 🛡️ Single Network Endpoint Connection ###
No risky direct connection between your clients and your object storage backend (even with presigned url).  Manage the single flow between your clients and the proxy.  All data travels through the proxy for both s3/hmac and presigned url connections.

### <span style="color: white; background-color: red; padding: 2px 5px; border-radius: 3px; font-weight: bold;">NEW!</span> Secure Access with Limited-Use Links
For secure access to your object storage, generate pre-signed URLs and restricted their usage to a limited number of uses to ensure security and prevent misuse.

### 🔒 Single-Point Policy Enforcement  
Write authorization rules once in **Python** (or call OPA, Redis, SQL—your choice). The proxy evaluates them *in-process* on every `DELETE`/`GET`/`HEAD`/`LIST`/`POST`/`PUT`/`...`, so compliance checks and tenant isolation happen at wire-speed, not in scattered app code.

<span style="color: white; background-color: red; padding: 2px 5px; border-radius: 3px; font-weight: bold;">NEW!</span> Apply fine-grained permissions on any prefix, make exceptions, etc.

### ⚡ Zero Extra Hop, Wire-Speed Throughput  
Because auth and streaming live in the **same memory space**, there’s no second network trip like with sidecars or external gateways. Data flows straight from bucket to client—up to **40 % lower p99 latency** in real-world benchmarks.

### 📊 Observability Where It Counts  
Built-in Prometheus metrics and OpenTelemetry traces wrap the exact bytes crossing the wire. You’ll see authentication failures, object sizes, and transfer times without bolting Lua or WASM onto a generic proxy.


---

### The Problems &lt;osp⚡&gt; Eliminates

| Pain Point | How We Solve It |
|------------|-----------------|
| **Credentials sprawl & secret leaks** | Front-end receives tokens; only the proxy holds bucket keys, so nothing sensitive reaches clients, browsers or notebooks. |
| **Slow, brittle presigned URL workflows** | Users hit one stable URL; the proxy handles signing on the fly. |
| **Security Risk, multiple direct network flows to object storage backends** | Clients do not connect directly to your object storage backend. |
| **Duplicate auth logic in every service** | Central policy engine with Python hooks—change rules in one place. |
| **Vendor lock-in & expensive rewrites** | Abstracts away bucket type; switch providers or split traffic without touching client code. |
| **Complex proxies that require custom plugins** | Lightweight binary / `pip` package; you extend it with plain Python, not unfamiliar DSLs. |

> **Bottom line:** &lt;osp⚡&gt; turns object-storage access into a fast, secure, one-line integration—so your team ships features instead of fighting buckets.


