#!/bin/sh


EMAIL="xxx"
KEY="xxx"
DT=`date +"%Y-%m%-d %H:%M:%S"`
HTTP_LOG_FILE=/var/log/httpd/`date +"%Y_%m_%d"`_access_log

get_zone_id(){
	domain_name=$1
	curl -s -X GET  -H "X-Auth-Email:$EMAIL"  -H "X-Auth-Key:$KEY" -H "Content-Type: application/json" \
	  "https://api.cloudflare.com/client/v4/zones?name=$domain_name&status=active&page=1&per_page=20&order=status&direction=desc&match=all" |jq '.result[] | {id}[]' |awk -F'"' '{print $2}'

}


create_firewall_rule(){
	ZONE_ID=$1
	JSON_RESULT=./result

	curl -s -X POST -H "X-Auth-Email:$EMAIL"  -H "X-Auth-Key:$KEY" -H "Content-Type: application/json" \
	-d '[ 
	  {"expression": "http.request.uri contains \"/?\"", "description":"wenhao"}
	]' "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/filters" > $JSON_RESULT


	NUM=`cat $JSON_RESULT |grep -i 'existing' |wc -l`
	if [ $NUM -eq 0 ];then
		FILTER_ID=`cat $JSON_RESULT |jq '.result[]|.id' |awk -F'"' '{print $2}'`
	else
		FILTER_ID=`cat $JSON_RESULT |jq '.errors[] |.meta["id"]' |awk -F'"' '{print $2}'` 
	fi


	curl -X POST -H "X-Auth-Email:$EMAIL"  -H "X-Auth-Key:$KEY" -H "Content-Type: application/json" \
	-d '[
	  {
	    "filter": {
	      "id": "'$FILTER_ID'"
	    },
	    "action": "block",
	    "description": "do not request wenhao."
	  }
	]' "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/firewall/rules"
}


echo "======= $DT ======"
tail -1000 $HTTP_LOG_FILE |awk -F'"' '{print $4}'  |grep -E 'https://.*/\?.*' |awk -F'/' '{print $3}' |sort |uniq -c |sort -rn |while read number domain
do
        if [ $number -gt 200 ];then
                zone_id=`get_zone_id "$domain"`
                create_firewall_rule "$zone_id"
        else
                echo "$domain 带问号异常请求数: $number "
        fi
done
