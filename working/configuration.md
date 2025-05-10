## Proxy

```python
    ProxyServerConfig(
        cos_map=cos_map,
        bucket_creds_fetcher=fetch_hmac_creds,
        validator=do_validation,
        http_port=6190,
        https_port=8443,
        threads=1,
        verify=False,
        hmac_keystore=hmac_keys,
        skip_signature_validation=False,
        hmac_fetcher=lookup_secret_key
    )
```

| argument | description | optional | default value |
| -------- | ----------- | -------- | ------------- |
| cos_map | bucket configuration, see below | | NA |
| bucket_creds_fetcher | python callable to retrieve credentials for a given bucket, to return either api key or hmac key pair | ✅ | NA |
| validator | python callable, validates access for a given token/bucket combination | ✅ | NA |
| http_port | server listener port on http | ✅ at least http_port or https_port, or both | NA |
| https_port | server listener port on https | ✅ at least http_port or https_port, or both | NA |
| threads | number of service threads | ✅ | 1 |
| verify | ignore ssl verification errors on backend storage (for dev purposes) | ✅ | False |
| hmac_keystore | | | |
| skip_signature_validation | ignore ssl verification errors on frontend (for dev purposes) | ✅ | False |
| hmac_fetcher | python callable, gets the private/secret key for a given public/access key | ✅ | NA |


## Buckets

- endpoint host
- port
- api key (optional)
- hmac access key (optional)
- hmac secret key (optional)
- ttl (optional, default 300) -> keep this reasonably short, but size to your needs

```json
cos_map = {
    "minimal-bucket1": {
        "host": "s3.eu-de.cloud-object-storage.appdomain.cloud",
        "port": 443,
        "ttl": 0
    },
    "api-key-bucket2": {
        "host": "s3.eu-de.cloud-object-storage.appdomain.cloud",
        "port": 443,
        "apikey": "apikey"
    },
    "proxy-bucket01": {
        "host": "s3.eu-de.cloud-object-storage.appdomain.cloud",
        "port": 443,
        "access_key": "<redacted>",
        "secret_key": "<redacted>",
        "ttl": 300
    },
    "proxy-aws-bucket01": {
        "host": "s3.eu-west-3.amazonaws.com",
        "region": "eu-west-3",
        "access_key": os.getenv("AWS_ACCESS_KEY"),
        "secret_key": os.getenv("AWS_SECRET_KEY"),
        "port": 443,
        "ttl": 300
    }    
}
```

## Python callback functions

| argument | description | signature | 
| -------- | ----------- | -------- | 
| bucket_creds_fetcher | python callable to retrieve credentials for a given bucket, to return either api key or hmac key pair |  <pre><code class="language-python">def callable(token: str, bucket: str) -> str </code></pre> |
| validator | python callable, validates access for a given token/bucket combination |  <pre><code class="language-python">def callable(token: str, bucket: str) -> bool </code></pre>  |
| hmac_fetcher | python callable, gets the private/secret key for a given public/access key | <pre><code class="language-python">def callable(access_key: str) -> Optional[str ] </code></pre> | NA |


```python
def do_hmac_creds(token: str, bucket: str) -> str:
    """ Fetch HMAC credentials (ro, rw, access_denied) for the given bucket, depending on the token """
    access_key = os.getenv("ACCESS_KEY")
    secret_key = os.getenv("SECRET_KEY")
    if not access_key or not secret_key:
        raise ValueError("ACCESS_KEY or SECRET_KEY environment variable not set")
        
    print(f"Fetching HMAC credentials for {bucket}...")

    return json.dumps({
        "access_key": access_key,
        "secret_key": secret_key
    })

def lookup_secret_key(access_key: str) -> str | None:
    # get all environment variables ending in ACCESS_KEY
    access_keys = [{key:value} for key, value in os.environ.items() if key.endswith("ACCESS_KEY") and value==access_key ]

    if len(access_keys) > 0:
        access_key_var = next((k for k, v in access_keys[0].items() if v == access_key), None)

        secret_key_var = access_key_var.replace("ACCESS_KEY", "SECRET_KEY")
        return os.getenv(secret_key_var, None)
    else:
        print(f"no access keys found for : {access_key}")


def do_validation(token: str, bucket: str) -> bool:
    """ Authorize the request based on token for the given bucket. 
        You can plug in your own authorization service here.
        The token is a client identifier used to fetch an authorization token and further authenticate/authorize.
        The bucket is the bucket name.
        The function should return True if the request is authorized, False otherwise.
    """

    print(f"PYTHON: Validating headers: {token} for {bucket}...")
    # return random.choice([True, False])
    return True
```