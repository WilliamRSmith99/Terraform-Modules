#/bin/bash


# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -d|--destroy) OPERATION="destroy" ;;
        -a|--apply) OPERATION="apply" ;;
        -u|--Wazuh_User) Wazuh_User="$2"; shift ;;
        -p|--Wazuh_Pass) Wazuh_Pass="$2"; shift ;;
        -g|--group) Group="$2"; shift ;;
        -l|--url) Url="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

## Check for JQ - install if not found
if [ ! $(which jq) ]; then
    sudo apt install jq -y
fi

Wazuh_token=$(curl -u  $Wazuh_User:"${Wazuh_Pass}" -k -X GET "https://${Url}:55000/security/user/authenticate?raw=true")
if [[ $OPERATION == "destroy" ]] ; then
    echo "destroy"
    curl -k -X DELETE "https://${Url}:55000/groups?groups_list=${Group}" -H "Authorization: Bearer ${Wazuh_token}" -H 'Content-Type: application/json'
elif [ $OPERATION == "apply" ]; then
    echo "apply"
    curl -k -X POST "https://${Url}:55000/groups" -H "Authorization: Bearer ${Wazuh_token}" -H 'Content-Type: application/json'  -d "{\"group_id\":\"${Group}\"}"
fi