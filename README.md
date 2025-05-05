# Welcome to &lt;osp⚡&gt; Object Storage Proxy

A blazingly fast and safe in-process gateway for AWS S3 and compatible services (IBM Cloud Object Storage, Minio, ...).

## Features

* Scalable extremely fast zero-latency gateway.
* Compatible with anything that supports the AWS SDK -> aws cli/boto3, Polars, Spark, Datafusion, Alteryx, Presto, dbt, ...
* Decouples frontend from backend authentication and authorization: plug in your authentication and authorization services. 
* Flexible extensible Python configuration and interface: pass in callables for credentials fetching, validation, lookup secret for access_key (with cache).
* Compatibility Gateway between systems that are limited to single hmac credentials pair, and distributed multi-vendor multi-credentials buckets backends.
* Seemlessly translate requests between path and virtual addressing style (ie. Alteryx).
* Compatible with corporate firewalled and proxied networks.
* Low-code integration in typical storage browsers with python backend (see [example #3](examples.md/#integrated-in-a-fastapi-app)).
* Support for presigned urls the same way as regular requests.
* Credentials support for classic hmac keypair and IBM api_key authentication.


__Find us here: [&lt;osp⚡&gt; Object Storage Proxy](https://osp.flexworks.eu)__