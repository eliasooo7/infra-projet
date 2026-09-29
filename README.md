# infra-projet

Projet IaC mixte Terraform + Ansible, avec scripts de cycle de vie Docker.

## 1. Structure du depot

~~~
terraform/environments/dev/   Code Terraform de l'environnement dev
terraform/integration/        Integration Terraform -> scripts Docker (null_resource)
ansible/playbooks/            Playbooks Ansible
ansible/roles/                Roles Ansible
scripts/                      deploy.sh / teardown.sh (cycle de vie conteneur)
app.py, Dockerfile            Application de demonstration (endpoint /health)
~~~

## 2. Prerequis

Git, Terraform (ou OpenTofu), Ansible (Linux/WSL2), Docker.

## 3. Utilisation

~~~bash
# Terraform
cd terraform/environments/dev && terraform init && terraform plan

# Ansible (inventory.ini non versionne, a creer localement)
ansible-playbook -i ansible/inventory.ini ansible/playbooks/site.yml

# Conteneur
./scripts/deploy.sh [version] [port]     # defaut : 1.0 8080
./scripts/teardown.sh [nom_conteneur]    # defaut : tp3-mon-app
~~~

## 4. Regles de contribution

- Une branche par changement : feature/..., fix/...
- Messages au format Conventional Commits (feat:, fix:, chore:, infra:)
- Aucun push direct sur main : Pull Request + 1 approbation obligatoires
- Force-push et suppression de main interdits

## 5. Securite

- Jamais de secret dans Git : *.tfvars, *.tfstate, inventory.ini, *.pem, *.key, .env sont ignores
- Seul example.tfvars (valeurs fictives) peut etre versionne
- Conteneur execute avec un utilisateur non-root
