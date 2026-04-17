.PHONY: syntax-check provision

syntax-check:
	ansible-playbook -i inventory/hosts.example.yml playbook.yml --syntax-check

provision:
	ansible-playbook -i inventory/hosts.yml playbook.yml
