
Any given client only requires a single set of credentials.  The backend credentials are abstracted from the client and managed by your business logic and company policies, using Python instead of complicated DSL (Domain Specific Language).

![S4 Cloud Object Storage Reverse Proxy](/img/architecture.png)

## Data Flow

There is no direct connection between your clients and object storage backends.

### traditional setup without &lt;osp⚡&gt;

![Traditional setup with presigned urlsy](/img/traditional_presigned_url.png)

### secure setup using &lt;osp⚡&gt;
The credentials are only fetched once at the initial connection.  Set a meaningful ttl (time-to-live) for each backend.  When the ttl expires, the process repeats. 

![Secure Simple Setup using &lt;osp⚡&gt;](/img/osp_presigned_url.png)

