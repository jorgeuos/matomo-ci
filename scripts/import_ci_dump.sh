#!/bin/bash

# mc cp minio/drone/mtmo/matomo-ci.sql.gz matomo-ci.sql.gz

gunzip matomo-ci.sql.gz

mysql -uroot -proot matomo-ci < matomo-ci.sql 2> /dev/null

