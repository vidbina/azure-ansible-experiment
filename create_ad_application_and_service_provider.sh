#!/bin/sh
APP_NAME="Ansible Test"
PASSWORD="secrets kill"

function azure_ad_app_create() {
  azure ad app create \
    --name "${APP_NAME}" \
    --password "${PASSWORD}" \
    --home-page "http://gw.${ENDPOINT}" \
    --identifier-uris "http://ansible.gw.${ENDPOINT}" > .azure_ad_app
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
APP_OBJECT_ID=$(get_azure_ad_app_object_id)
APP_ID=$(get_azure_ad_app_id)

echo "App Object ID: ${APP_OBJECT_ID}"
echo "App ID: ${APP_ID}"

azure ad sp create $APP_ID > .azure_ad_sp
SP_OBJECT_ID=$(get_azure_ad_sp_object_id)
echo "SP Object ID: ${SP_OBJECT_ID}"

SUBSCRIPTION_ID="6210d80f-6574-4940-8f97-62e3f455d194"
TENANT_ID="0ec590e9-f54b-487a-80b7-294fe9527aab"

azure role assignment create --objectId ${SP_OBJECT_ID} \
  -o Reader -c "/subscriptions/${SUBSCRIPTION_ID}/"

azure login -u $APP_ID -p "${PASSWORD}" --service-principal --tenant ${TENANT_ID}
