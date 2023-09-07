.PHONY:

clear:
	rm -rf gen

buf-gen-order:
	buf generate --path proto/order

buf-gen-payment:
	buf generate --path proto/payment

buf-gen-shipping:
	buf generate --path proto/shipping

buf-lint-order:
	buf lint --path proto/order

buf-lint-payment:
	buf lint --path proto/payment

buf-lint-shipping:
	buf lint --path proto/shipping
