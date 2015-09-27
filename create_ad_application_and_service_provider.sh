#!/bin/sh
APP_NAME="Ansible Test"
PASSWORD="secrets kill"
OUTPUT_RESET="\033[0m"
OUTPUT_GREEN="\033[0;32m"
OUTPUT_RED="\033[0;31m"
OUTPUT_PINK="\033[1;31m"

if test -z $ENDPOINT; then
  echo "${OUTPUT_RED}ENDPOINT must be specified${OUTPUT_RESET}"; exit
fi

function azure_ad_app_create() {
  set -x
  azure ad app create \
    --name "${APP_NAME}" \
    --password "${PASSWORD}" \
    --home-page "http://gw.${ENDPOINT}" \
    --identifier-uris "http://ansible.gw.${ENDPOINT}" > .azure_ad_app
  set +x
}

function get_azure_ad_app_id() {
  cat .azure_ad_app | grep "Application Id" | \
  awk \
  'match($0, /[a-z0-9]{4,12}(-[a-z0-9]{4,12}){4}/) {
    print substr($0, RSTART, RLENGTH)
  }'
}

function get_azure_ad_app_object_id() {
  cat .azure_ad_app | grep "Application Object Id" | \
  awk \
  'match($0, /[a-z0-9]{4,12}(-[a-z0-9]{4,12}){4}/) {
    print substr($0, RSTART, RLENGTH)
  }'
}

function get_azure_ad_sp_object_id() {
  cat .azure_ad_sp | grep "Object Id" | \
  awk \
  'match($0, /[a-z0-9]{4,12}(-[a-z0-9]{4,12}){4}/) {
    print substr($0, RSTART, RLENGTH)
  }'
}

azure_ad_app_create
echo "${OUTPUT_GREEN}==================================${OUTPUT_RESET}"
APP_OBJECT_ID=$(get_azure_ad_app_object_id)
APP_ID=$(get_azure_ad_app_id)

echo "${OUTPUT_GREEN}App Object ID: ${APP_OBJECT_ID}${OUTPUT_RESET}"
echo "${OUTPUT_GREEN}App ID: ${APP_ID}${OUTPUT_RESET}"

# https://azure.microsoft.com/en-us/documentation/articles/resource-group-authenticate-service-principal/#_authenticate-service-principal-with-password---azure-cli
set -x
azure ad sp create ${APP_ID} > .azure_ad_sp
set +x

SP_OBJECT_ID=$(get_azure_ad_sp_object_id)
echo "${OUTPUT_GREEN}SP Object ID: ${SP_OBJECT_ID}${OUTPUT_RESET}"

SUBSCRIPTION_ID="6210d80f-6574-4940-8f97-62e3f455d194"
TENANT_ID="0ec590e9-f54b-487a-80b7-294fe9527aab"
sleep 10

set -x
azure role assignment create --objectId ${SP_OBJECT_ID} \
  -o Reader -c "/subscriptions/${SUBSCRIPTION_ID}/"

azure login -u $APP_ID -p "${PASSWORD}" --service-principal --tenant ${TENANT_ID}
set +x

echo "${OUTPUT_PINK}azure ad app delete ${APP_OBJECT_ID}${OUTPUT_RESET}"
