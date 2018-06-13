FROM alpine:3.7

WORKDIR /app 

ENV TOX_VERSION 2.9.1

ENV PYTHON_VERSIONS="\
    2.7.15 \
    3.5.5 \
    3.6.5 \
    "

ENV PACKAGES="\
    dumb-init \
    musl \
    libc6-compat \
    linux-headers \
    build-base \
    bash \
    git \
    ca-certificates \
    libffi-dev \
    openssl-dev \
    "

# PACKAGES needed to built python
ENV PYTHON_BUILD_PACKAGES="\
    readline-dev \
    zlib-dev \
    bzip2-dev \
    sqlite-dev \
    "

ENV PYENV_ROOT /usr/lib/pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

RUN set -ex ;\
    # Add the base packages
    apk add --no-cache $PACKAGES ;\
    \
    # Add packages just for the python build process
    apk add --no-cache --virtual .build-deps $PYTHON_BUILD_PACKAGES ;\
    \
    # use pyenv to download and compile specific python version
    git clone --depth 1 https://github.com/pyenv/pyenv /usr/lib/pyenv ;\
    export CFLAGS='-O2' ;\
    eval "$(pyenv init -)" ;\
    echo ${PYTHON_VERSIONS} | xargs -n1 ${PYENV_ROOT}/bin/pyenv install ;\
    ${PYENV_ROOT}/bin/pyenv global $PYTHON_VERSIONS ;\
    pip install --upgrade pip ;\
    pyenv rehash ;\
    \
    # install tox
    ${PYENV_ROOT}/bin/pyenv versions ;\
    pip install tox==$TOX_VERSION ;\
    rm -rf /root/.cache/pip ;\
    \
    # remove build dependencies and any leftover apk cache
    apk del --no-cache --purge .build-deps ;