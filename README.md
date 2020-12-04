# Cloud PV Migration
Utilize cli tools to migrate cloud storage from one cluster to another without removing the volumes. Utilize individual shell scripts glued by a make file.

Each make command will execute the underlying shell scripts from the `/scripts` dir.

## WARNING
This only works for cloud volumes managed by the cloud providers and ony tested with azure azure disk currently though the process has been tested with Azure Files and Amazon EBS volumes.

## Running
`make validate OLD=path_to_old_kubeconfig NEW=path_to_new_kubeconfig NAMESPACE=namespace_to_migreate`

If no errors return then you may go forward to prepare and other steps do not require arguments.

## Commands / Steps	
### default: List Commands
### validate(Default): (path to old cluster kubeconfig) (path to new cluster kube config) (namespace to migrate)
	. kubectl - validate that kubectl is installed.
	. kubeconfig (original) - validate originating kubeconfig file.
	. kubeconfig (new) - validate new kubeconfig file.
	. namespace (original) - validate namespace on orig cluster
	. namespace (new) - validate namespace on new cluster
	. match - make sure the pvs match at both sides. (New workloads created with blank data already.)
	. temp-create (on exec fs) - create a temp directory and copy kubeconfigs and set 
namespaces.

### prepare: - executes on temp directory
	. ready - check to make sure we are ready to proceed with step
	. reclaim-policy - change reclaim policy
	. export-pvc - export and clean pvc
	. export-pv - export and clean pv
	. clean (new) - remove pv and pvc entries from new cluster.
	
### create: (new) - creates new records on new cluster
	. ready - check to make sure we are ready to proceed with step
	. pvc - create the pvc from exports
	. pv - create the pv from exports
	
### migrate: - remove binds from old cluster and add to new cluster.
	. ready - check to make sure we are ready to proceed
	. delete (old) - remove pvc from old cluster to unbind.
	
### clean: - clean execution machine
	. ready - check to make sure we are ready to proceed
	. temp-delete - remove temp dir
# cpvm
