ROLE_ARN := $(shell cd bootstrap && terraform output -raw role_arn 2>/dev/null)

.PHONY: bootstrap plan deploy destroy bootstrap-destroy

bootstrap:
	cd bootstrap && terraform init && terraform apply

plan:
	./scripts/assume-role.sh $(ROLE_ARN) terraform plan

deploy:
	terraform init
	./scripts/assume-role.sh $(ROLE_ARN) terraform apply

destroy:
	./scripts/assume-role.sh $(ROLE_ARN) terraform destroy

bootstrap-destroy:
	cd bootstrap && terraform destroy
