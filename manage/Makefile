.PHONY: fmt
fmt:
	terraform fmt

.PHONY: init
init:
	terraform init \
		-reconfigure \
		--backend-config=bucket=${AWS_S3_BUCKET}
