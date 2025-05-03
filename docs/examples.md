## example 1
Upload to an aws bucket. Profile osps is using &lt;osp⚡&gt; over https, myaws is direct.

![aws upload](img/output.webp)

## example 2

![duckdb](img/DuckDB_Logo-horizontal.svg){ width=120px }

1. Generate some [TCPH](https://www.tpc.org/tpch/) testdata using <i class="fab fa-github"> </i> [dbgen](https://github.com/jeroenflvr/dbgen) with a table on an aws bucket and another table on an ibm cos bucket.

2. Create two views, join them and write the results to one of the buckets.  All using just 1 set of credentials.



## example 3
Using &lt;osp⚡&gt; as download/upload interface in a fastapi python backend (using [&lt;/&gt; htmx](https://htmx.org/) for our convenience)

When a download link is clicked, present a presigned link in either a dialog or hidden on the page and use javascript to click it so the download starts.


