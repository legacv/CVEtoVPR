#!/bin/bash
# bash script to use the Tenable API to fetch the VPR score for a given CVE
# make sure to make your .env with your keys before you call this
# MIT license

source .env

# check for dict existence
dictionary() {
        if [ ! -f ./pluginsList.txt ]; then
                echo "[*] No plugins list detected in this directory. Creating one..."
                touch ./pluginsList.txt
        elif [[ -f ./pluginsList.txt && -s ./pluginsList.txt ]]; then
                echo "[*] Plugins list detected and is not empty. rm ./pluginsList.txt and re-run"
                exit 1;
        fi
}

 find out how many pages are needed to get all plugins
paginate() {
        # fetch total no. of plugins
        numberPlugins=$(curl -sS --request GET \
     --url https://cloud.tenable.com/plugins/plugin?size=10000 \
     --header "X-ApiKeys: accessKey=$TENABLE_ACCESS_KEY; secretKey=$TENABLE_SECRET_KEY;" \
     --header "accept: application/json" | jq '.total_count')
        # find number of pages needed by ceil
        pages=$(( ($numberPlugins+9999)/10000 ))
        echo $pages
}

# get plugins, 10k at a time, all pages, & sort output into dict
getPlugins() {
    pages=$(paginate)
    echo "[*] ${pages} page(s) to go through. Matching plugins to CVEs..."
    for (( i=1; i<=pages; i++ )) ; do
        curl -sS --request GET \
            --url "https://cloud.tenable.com/plugins/plugin?size=10000&page=${i}" \
            --header "X-ApiKeys: accessKey=${TENABLE_ACCESS_KEY}; secretKey=${TENABLE_SECRET_KEY}" \
            --header "accept: application/json" | \
            jq '[.data.plugin_details[] | {id, cve: .attributes.cve}]' >> pluginsList.txt
    done
    echo "[*] Plugin dictionary created. Run: head -n 20 ./pluginsList.txt to check it."
}

#  process single entry
single() {
        # grab ID from CVE list
        pluginIDPlural=$(cat ./pluginsList.txt | jq --arg cve "$1" '.[] | select(.cve[]? == $cve) | .id')
        # jq misbehaving returning 500039 even when wrapped in first(). using cut to cut
        pluginID=$(echo $pluginIDPlural | cut -d' ' -f1)
        # get plugin info
        out=$(curl -sS --request GET \
        --url "https://cloud.tenable.com/workbenches/vulnerabilities/${pluginID}/info" \
        --header "X-ApiKeys: accessKey=$TENABLE_ACCESS_KEY; secretKey=$TENABLE_SECRET_KEY;" \
        --header "accept: application/json")
        echo $out
}

# process file of entries
list() {
    while IFS= read -r line; do
        single
    done < $1
}

# display usage
usage() { echo "Usage: $0 [-u] [-c <CVE>] [-f <file>] [-h]" 1>&2; exit 0; }

while getopts 'huc:f:' opt; do
  case "$opt" in
    u)
        echo "[*] Updating plugins... (This may take a while)"
        dictionary;
        getPlugins;
      ;;

    c)
        arg="$OPTARG"
        echo "Processing option 'c' with '${OPTARG}' argument"
        out=$(single $arg)
        echo $out
      ;;

    f)
        arg="$OPTARG"
        echo "Processing option 'f' with '${OPTARG}' argument"
        list $arg
      ;;

    ?|h)
        usage
      ;;

  esac
done
shift "$(($OPTIND -1))"
