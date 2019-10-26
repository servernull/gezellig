#!/bin/sh

URL=http://scottleedavis.com/

echo $URL | faas-cli invoke openfaas-imagecrawler > image_urls.txt

cat image_urls.txt
# cat image_urls.txt | faas-cli invoke openfaas-exiffeed

