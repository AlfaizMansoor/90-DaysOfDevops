# Day 72 -- Ansible Project: Automate Docker and Nginx Deployment
## TASK-1
1. I Create the complete project layout:

```
ansible-docker-project/
  ansible.cfg
  inventory.ini
  site.yml                          # Master playbook
  group_vars/
    all.yml                         # Common variables
    web/
      vars.yml                      # Nginx variables
      vault.yml                     # Encrypted Docker Hub credentials
  roles/
    common/                         # Shared setup for all servers
      tasks/main.yml
    docker/                         # Docker installation and container management
      tasks/main.yml
      templates/
        docker-compose.yml.j2
      handlers/main.yml
      defaults/main.yml
    nginx/                          # Nginx reverse proxy
      tasks/main.yml
      templates/
        nginx.conf.j2
        app-proxy.conf.j2
      handlers/main.yml
      defaults/main.yml
```

2. Later i generate the role skeletons:
```bash
mkdir -p ansible-docker-project/roles
cd ansible-docker-project
ansible-galaxy init roles/common
ansible-galaxy init roles/docker
ansible-galaxy init roles/nginx
```

3. I set up my `ansible.cfg` and `inventory.ini` 
---

## TASK-2
The `common` role runs on every server -- baseline packages and setup.

**`roles/common/tasks/main.yml`:**
```yaml
---
- name: Update package cache
  yum:
    update_cache: true
  tags: common

- name: Install common packages
  yum:
    name: "{{ common_packages }}"
    state: present
  tags: common

- name: Set hostname
  hostname:
    name: "{{ inventory_hostname }}"
  tags: common

- name: Set timezone
  timezone:
    name: "{{ timezone }}"
  tags: common

- name: Create deploy user
  user:
    name: deploy
    groups: wheel
    shell: /bin/bash
    state: present
  tags: common
```

**`group_vars/all.yml`:**
```yaml
---
timezone: Asia/Kolkata
project_name: devops-app
app_env: development
common_packages:
  - vim
  - curl-minimal
  - wget
  - git
  - htop
  - tree
  - jq
  - unzip
```

---

## TASK-3
**`roles/docker/defaults/main.yml`:**
```yaml
---
docker_app_image: nginx
docker_app_tag: latest
docker_app_name: myapp
docker_app_port: 8080
docker_container_port: 80
```

**`roles/docker/tasks/main.yml`:**
I Write tasks that:
1. Install Docker dependencies (`yum-utils`, `device-mapper-persistent-data`, `lvm2`)
2. Add the Docker CE repository
3. Install Docker CE
4. Start and enable the Docker service
5. Add the `deploy` user to the `docker` group
6. Install Docker Compose (via pip or direct download)
7. Log in to Docker Hub using vault-encrypted credentials:
8. Pull the application image:
9. Run the container:
10. Verify the container is running:
```yaml
---
# tasks file for roles/docker
- name: Installing docker dependencies
  dnf:
    name:
      - dnf-utils
      - lvm2
      - device-mapper-persistent-data
    state: present

- name: Adding docker ce repo
  yum_repository:
    name: docker-ce-stable
    description: Docker CE Stable 
    baseurl: https://docker.com
    gpgcheck: true
    gpgkey: https://docker.com
    enabled: true

- name: Install docker ce
  dnf:
    name: docker
    state: present
    update_cache: true

- name: Start and Enable docker services
  systemd:
    name: docker
    state: started
    enabled: true
    daemon_reload: true

- name: Ensure deploy user exists and is in docker group
  user:
    name: deploy
    groups: docker
    append: true
    state: present

- name: Install pip
  dnf:
    name: python3-pip
    state: present

- name: Install docker-compose
  pip:
    name:
      - requests<2.32.0
      - urllib3<2.0
      - docker 
      - docker-compose
    state: present
    extra_args: --ignore-installed

- name: Log in to Docker Hub
  community.docker.docker_login:
    username: "{{ vault_docker_username }}"
    password: "{{ vault_docker_password }}"
  become_user: deploy

- name: Pull application image
  community.docker.docker_image:
    name: "{{ docker_app_image }}"
    tag: "{{ docker_app_tag }}"
    source: pull

- name: Run application container
  community.docker.docker_container:
    name: "{{ docker_app_name }}"
    image: "{{ docker_app_image }}:{{ docker_app_tag }}"
    state: started
    restart_policy: always
    ports:
      - "{{ docker_app_port }}:{{ docker_container_port }}"

- name: Wait for container to be healthy
  uri:
    url: "http://localhost:{{ docker_app_port }}"
    status_code: 200
  retries: 5
  delay: 3
  register: health_check
  until: health_check.status is defined and health_check.status == 200
  when: not ansible_check_mode
```

Tag all tasks with `docker`.

**`roles/docker/handlers/main.yml`:**
```yaml
---
- name: Restart Docker
  service:
    name: docker
    state: restarted
```

**Install the required Ansible collection** (needed for `community.docker` modules):
```bash
ansible-galaxy collection install community.docker
```

---

## TASK-4
This role installs Nginx and configures it as a reverse proxy to the Docker container.

**`roles/nginx/defaults/main.yml`:**
```yaml
---
nginx_http_port: 80
nginx_upstream_port: 8080
nginx_server_name: "_"
```

**`roles/nginx/tasks/main.yml`:**
Write tasks that:
1. Install Nginx
2. Remove the default Nginx site config
3. Deploy the main Nginx config from a template
4. Deploy the reverse proxy config from a template
5. Test Nginx config before reloading:
6. Start and enable Nginx
7. Use a handler to reload Nginx when any config changes
```yaml
---
# tasks file for roles/nginx
- name: Install Nginx
  dnf:
    name:
      - nginx
    state: present

- name: Remove default nginx page
  file:
    path: /etc/nginx/conf.d/default.conf
    state: absent
  notify: Reload Nginx

- name: Create web root
  file:
    path: "/var/www/{{ app_name }}"
    state: directory
    mode: '0755'

- name: deploying reverse proxy
  template:
    src: app-proxy.conf.j2
    dest: "/etc/nginx/conf.d/{{ app_name }}.conf"
    owner: root
    mode: '0644'
  notify: Restart Nginx

- name: Test Nginx configuration
  command: nginx -t
  changed_when: false

- name: Start and Enable Nginx
  service: 
    name: nginx
    state: started
    enabled: true
```

Tag all tasks with `nginx`.

**`roles/nginx/templates/app-proxy.conf.j2`:**
```nginx
# Reverse Proxy to Docker Container -- Managed by Ansible
upstream docker_app {
    server 127.0.0.1:{{ nginx_upstream_port }};
}

server {
    listen {{ nginx_http_port }};
    server_name {{ nginx_server_name }};

    location / {
        proxy_pass http://docker_app;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /health {
        access_log off;
        return 200 'OK';
        add_header Content-Type text/plain;
    }

{% if app_env == 'production' %}
    access_log /var/log/nginx/{{ project_name }}_access.log;
    error_log /var/log/nginx/{{ project_name }}_error.log;
{% else %}
    access_log /var/log/nginx/{{ project_name }}_access.log;
    error_log /var/log/nginx/{{ project_name }}_error.log debug;
{% endif %}
}
```

**`roles/nginx/handlers/main.yml`:**
```yaml
---
- name: Reload Nginx
  service:
    name: nginx
    state: reloaded

- name: Restart Nginx
  service:
    name: nginx
    state: restarted
```

---

## TASK-5
1. Create the vault file:
```bash
ansible-vault create group_vars/web/vault.yml
```
Add:
```yaml
vault_docker_username: ##########
vault_docker_password: ##########
```

2. Create a vault password file for convenience:
```bash
echo "##########" > .vault_pass
chmod 600 .vault_pass
echo ".vault_pass" >> .gitignore
```

3. Reference it in `ansible.cfg`:
```ini
[defaults]
inventory = inventory.ini
host_key_checking = False
vault_password_file = .vault_pass
```

---

## TASK-6
**`site.yml`:**
```yaml
---
- name: Apply common configuration
  hosts: all
  become: true
  roles:
    - common
  tags: common

- name: Install Docker and run containers
  hosts: web
  become: true
  roles:
    - docker
  tags: docker

- name: Configure Nginx reverse proxy
  hosts: web
  become: true
  roles:
    - nginx
  tags: nginx
```

Deploy the full stack:
```bash
# Dry run first -- always
ansible-playbook site.yml --check --diff

# Full deploy
ansible-playbook site.yml
```
![alt text](<Screenshot From 2026-11-19 13-19-49.png>)

Use tags for selective execution:
```bash
# Only set up Docker and containers
ansible-playbook site.yml --tags docker
```
![alt text](<Screenshot From 2026-11-19 13-20-35.png>)

```bash
# Only update Nginx config
ansible-playbook site.yml --tags nginx
```
![alt text](<Screenshot From 2026-11-19 13-21-59.png>)

```bash
# Skip common setup
ansible-playbook site.yml --skip-tags common
```

**Verify:**
1. Curl the server on port 8080 -- does the Docker container respond directly?
* I curl the server port on 8080 and the container does'nt responds directly.

2. Curl the server on port 80 -- does Nginx reverse proxy the request to the container?
* I curl the server port on 80 and the container responds directly.

![alt text](<Screenshot From 2026-11-19 13-23-39.png>)

3. Check `docker ps` on the server -- is the container running with the correct port mapping?
* I checked the web server host and verifies that container named **"myapp"** is running.

![alt text](<Screenshot From 2026-11-19 13-38-07.png>)

---

## TASK-7
**Reflect and document:**
1. How many total tasks ran?
* Total 20 tasks runs

2. Map each Ansible concept to the day you learned it:

| Day | Concept Used |
|-----|-------------|
| 68 | Inventory, ad-hoc commands, SSH setup |
| 69 | Playbooks, modules, handlers |
| 70 | Variables, facts, conditionals, loops |
| 71 | Roles, templates, Galaxy, Vault |
| 72 | Everything combined in one project |

3. What would you add for production? (SSL with certbot, monitoring, log rotation, multi-container Compose)
4. Clean up your EC2 instances when done. If you used Terraform: `terraform destroy`. If manual: terminate from the console.

---