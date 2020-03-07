# redis-server

To install the pre-compiled Redis binaries:

```sh
pip install redis-server==<redis-version>
```

Supported `redis-version`:

- `5.0.7`
- `6.0rc2`

Supported platforms:

- `manylinux2010_x86_64`
- `manylinux2010_i686`
- `macosx_10_15_x86_64`

Supported python versions:

- `cp35`
- `cp36`
- `cp37`
- `cp38`

To get the paths of pre-compiled Redis binaries:

```python
import redis_server

redis_server.REDIS_SERVER_PATH  # redis-server
redis_server.REDIS_CLI_PATH     # redis-cli
```
