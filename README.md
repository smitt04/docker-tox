# tox

Allows running your tests through tox. A tox.ini file is required.

## Setup
You need to mount or add code under the `/app` path.

You can just run with the `tox` comnmand.

### Example
An example running tox locally.

```bash
docker run -it -v `pwd`:/app smitt04/tox tox
```