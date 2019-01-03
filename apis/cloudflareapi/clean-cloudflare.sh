#!/bin/sh


EMAIL="xxx"
KEY="xxx"

ID_LIST_FILE=./list

curl -s -X GET "https://api.cloudflare.com/client/v4/zones?status=active&page=1&per_page=200&order=status&direction=desc&match=all"    -H "X-Auth-Email:$EMAIL"  -H "X-Auth-Key:$KEY" -H "Content-Type: application/json"  | jq '.result[] | {id}[]' > $ID_LIST_FILE


awk -F'"' '{print $2}' list  |while read i ; do curl -X DELETE https://api.cloudflare.com/client/v4/zones/$i/purge_cache -H "X-Auth-Email:$EMAIL" -H "X-Auth-Key:$KEY" -H "Content-Type:application/json" --data '{"purge_everything":true}' ; done
