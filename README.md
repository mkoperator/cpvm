# Cloud PV Migration
Utilize cli tools to migrate cloud storage from one cluster to another without removing the volumes. Utilize individual shell scripts glued by a make file. A temporary directory is used to store both kubeconfigs and pv/pvc files during the migration. 

Each make command will execute the underlying shell scripts from the `/scripts` dir.

The temporary directory (.tmp) will be created in the `make prepare` phase and will use the `/.temp-tempate` as its base.

## WARNING
This only works for cloud volumes managed by the cloud providers and ony tested with azure azure disk currently though the process has been tested with Azure Files and Amazon EBS volumes.

## Running
 - `make validate OLD=path_to_old_kubeconfig NEW=path_to_new_kubeconfig NAMESPACE=namespace_to_migreate`

If no errors return then you may go forward to prepare and other steps do not require arguments.
 - `make prepare`
 - `make create`
 - `make migrate`
 - `make clean`

## Commands / Steps	
### default 
List available commands. (no argument to `make`)

### validate 
First step is to validate we are able to complete this migration. Check above for the required input variables OLD, NEW, and NAMESPACE.
 - kubectl - validate that kubectl is installed.
 - kubeconfig (original) - validate originating kubeconfig file.
 - kubeconfig (new) - validate new kubeconfig file.
 - namespace (original) - validate namespace on orig cluster
 - namespace (new) - validate namespace on new cluster
 - match - make sure the pvs match at both sides. (New workloads created with blank data already.)
 - temp-create (on exec fs) - create a temp directory and copy kubeconfigs and set 
namespaces.

### prepare
Executes on temp directory.
 - ready - check to make sure we are ready to proceed with step
 - reclaim-policy - change reclaim policy
 - export-pvc - export and clean pvc
 - export-pv - export and clean pv
 - clean (new) - remove pv and pvc entries from new cluster.
	
### create
Creates new records on new cluster.
 - ready - check to make sure we are ready to proceed with step
 - pvc - create the pvc from exports
 - pv - create the pv from exports
	
### migrate
Remove binds from old cluster and add to new cluster.
 - ready - check to make sure we are ready to proceed
 - delete (old) - remove pvc from old cluster to unbind.
	
### clean
Clean execution machine.
 - ready - check to make sure we are ready to proceed
 - temp-delete - remove temp dir

## Temp Directory (.tmp)
The temp directory will contain only validated kubeconfigs set to the proper namespace and pv/pvc files in various stages of migration. The directory is copied from `.temp-template` directory in the repository and copied as `.tmp`.
 - new_kubeconfig.yaml - location of new cluster's kubeconfig.
 - old_kubeconfig.yaml - location of old cluster's kubeconfig.
 - /to-clean - After export but before cleaning, pv/pvc files are stored here.
 - /to-migrate - After cleaning they are stored here.
 - /migrated - Complete pv and pvcs.