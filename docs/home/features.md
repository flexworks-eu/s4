
* Scalable fast in-process gateway.
* Compatible with anything that supports the AWS SDK -> aws cli/boto3, Polars, Spark, Datafusion, Presto, dbt, ...
* Decouples frontend from backend authentication and authorization: plug in your authentication and authorization services. 
* Flexible extensible Python configuration and interface: pass in callables for credentials fetching, validation, lookup secret for access_key (with cache).
* Compatibility Gateway between systems that are limited to single hmac credentials pair, and distributed multi-vendor multi-credentials buckets backends.
* Seemlessly translate requests between path and virtual addressing style.
* Compatible with corporate firewalled and proxied networks.
* Low-code integration in typical storage browsers with python backend (see [example #3](index.md/#integrated-in-a-fastapi-app)).
* Support for presigned urls the same way as regular requests.
* Credentials support for classic hmac keypair and IBM api_key authentication.
* Apply fine-grained permissions on any prefix, make exceptions
* <span style="color: white; background-color: red; padding: 2px 5px; border-radius: 3px; font-weight: bold;">NEW!</span> Distributed Cache.  When you are running multiple instances, expensive credentials fetching and authorization roundtrips are called just once.


