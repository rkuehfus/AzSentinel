#Create custom Role
az role definition create --role-definition ./rgreader.json

#List the new custom role
az role definition list --name "RG Player Read access" --output json | jq '.[] | .permissions[0].actions'
az role definition list --name "Contributor" --output json | jq '.[] | .permissions[0].actions'
az role definition list --name "Log Analytics Reader" --output json | jq '.[] | .permissions[0].actions'

#update role
az role definition update --role-definition ./rgreader.json

#Delete Custom Role
az role definition delete --name "RG Player Read access"