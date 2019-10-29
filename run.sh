#!/bin/sh

URL=http://scottleedavis.com/

echo $URL | faas-cli invoke openfaas-imagecrawler | jq > image_urls.txt

cat image_urls.txt | faas-cli invoke openfaas-exiffeed --async --header "X-Callback-Url=https://enn0xtojsdq2r.x.pipedream.net"

# input="./image_urls.txt"
# while IFS= read -r line
# do
# 	line="${line%\"}"
# 	line="${line#\"}"
# 	echo $line | faas-cli invoke inception | jq 
# done < $input

cat image_urls.txt | faas-cli invoke openfaas-opennsfwfeed --async --header "X-Callback-Url=https://enn0xtojsdq2r.x.pipedream.net"

