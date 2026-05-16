Performance is pretty good.  Even when using the python callback functions, since they're only called once and then cached for the remainder of the requests or until ttl expiration.

An upload to aws bucket: the osps profile is using &lt;osp⚡&gt; over https, myaws is direct.

> For more detailed benchmarks, please check out this [benchmarks doc in the project's github repo](https://github.com/opensourceworks-org/object-storage-proxy/blob/main/BENCHMARKS.md), where we conclude that the proxy does not add measurable overhead.

![aws upload](../img/output.webp)