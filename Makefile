# Cloud PV Migration
# Contains commands to migrate all the persistent volumes of a namespace from one cluster to another.
# Note this only works with cloud based storage such as Azure Disk, Azure File, Amazon EBS...
# Consult README.md for more info.
default:
	@echo "Cloud PV Migration"
	@echo "Check readme for list of available command options."
	@echo "------------------"
	@echo "validate"
	@echo "prepare"
	@echo "create"
	@echo "migrate"
	@echo "clean"

validate:
	@echo "Validating."
# Checking to make sure kubectl exists on executing machine.
	@scripts/validate-kubectl.sh 
# validating old cluster kubeconfig
	@scripts/validate-kubeconfig.sh $(OLD)
# validating new cluster kubeconfig
	@scripts/validate-kubeconfig.sh $(NEW)
# validate namespace in old cluster
	@scripts/validate-namespace.sh $(OLD) $(NAMESPACE) 
# validate namespace in new cluster
	@scripts/validate-namespace.sh $(NEW) $(NAMESPACE) 
# match new cluster namespace with old
	@scripts/validate-match.sh $(OLD) $(NEW) $(NAMESPACE)
# create temporary dir (.tmp) for processing the migration based on .temp-template
	@scripts/validate-temp-create.sh $(OLD) $(NEW) $(NAMESPACE)

prepare:
	@echo "Preparing."
# confirming ready for this step.
	@scripts/prepare-ready.sh
# setting reclaim policy to not remove volumes when unbound
	@scripts/prepare-reclaim-policy.sh
# export pvc from old cluster
	@scripts/prepare-export-pvc.sh
# export pv from old cluster
	@scripts/prepare-export-pv.sh
# clean pv and pvc and move them to new dir.
	@scripts/prepare-clean.sh

create:
	@echo "Creating."
# confirming ready for this step.
	@scripts/create-ready.sh
# create pvc
	@scripts/create-pvc.sh
# create pv and modify
	@scripts/create-pv.sh

migrate:
	@echo "Migrating."
# confirming ready for this step.
	@scripts/migrate-ready.sh
# delete pv and pvc records in old cluster.
	@scripts/migrate-delete.sh

clean:
	@echo "Cleaning."
# confirming ready for this step.
	@scripts/clean-ready.sh
# delete temporary directory.
	@scripts/clean-temp-delete.sh