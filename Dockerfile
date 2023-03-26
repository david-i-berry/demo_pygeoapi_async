FROM wmoim/dim_eccodes_baseimage:2.28.0

ENV TZ="Etc/UTC" \
    DEBIAN_FRONTEND="noninteractive" \
    PYGEOAPI_CONFIG="/config/pygeoapi-config.yml" \
    PYGEOAPI_OPENAPI="/config/openapi-config.yml"

RUN echo "Acquire::Check-Valid-Until \"false\";\nAcquire::Check-Date \"false\";" | cat > /etc/apt/apt.conf.d/10no--check-valid-until \
    && apt-get update -y \
    && pip3 install --no-cache-dir https://github.com/wmo-im/csv2bufr/archive/pygeoapi-debug.zip \
    && pip3 install --no-cache-dir https://github.com/geopython/pygeoapi/archive/master.zip

WORKDIR /tmp
COPY requirements-providers.txt .

RUN pip3 install -r requirements-providers.txt
RUN rm -R /tmp

ADD ./config /config

# create openapi config file
RUN pygeoapi openapi generate $PYGEOAPI_CONFIG > $PYGEOAPI_OPENAPI
