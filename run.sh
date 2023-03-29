#! /bin/sh

docker build -t lnmisagal/cignal .
docker run -dit --name test lnmisagal/cignal
docker push lnmisagal/cignal
