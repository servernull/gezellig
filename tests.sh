
URL=http://scottleedavis.com/

# echo $URL | faas-cli invoke openfaas-imagecrawler | jq > image_urls.txt

# test if images make it through exif feed
cat low_image_urls.txt | faas-cli invoke openfaas-exiffeed --async --header "X-Callback-Url=http://gateway:8080/function/openfaas-elastic"
cat med_image_urls.txt | faas-cli invoke openfaas-exiffeed --async --header "X-Callback-Url=https://enkfdp3ow6jme.x.pipedream.net/"
cat low_image_urls.txt | faas-cli invoke openfaas-exiffeed --async --header "X-Callback-Url=http://192.168.0.22:4444"
cat high_image_urls.txt | faas-cli invoke openfaas-exiffeed --async --header "X-Callback-Url=http://gateway:8080/function/openfaas-elastic"


# cat low_image_urls.txt | faas-cli invoke openfaas-opennsfwfeed --async --header "X-Callback-Url=https://enn0xtojsdq2r.x.pipedream.net"

