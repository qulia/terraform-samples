### Terraform KV Provider
Simple terraform provider that manipulates local key-value store. The resources are key,value
pairs in the map. The id of the resources is the key and CRUD operations invoked by terraform 
reflected in the state in the map. For example, create add the entry in the map, destroy command
invokes delete and hence removes the entry from the map

All operations are local. 

Steps to run kv provider and apply the manifest on Mac

Note vendor directory was created with "go mod vendor"

`One time installation: brew install terraform

cd custom-providers/kv

go build -o terraform.d/plugins/darwin_amd64/terraform-provider-kv

Run the validation script and examine the traces for lifecycle operations
./validate.sh




 