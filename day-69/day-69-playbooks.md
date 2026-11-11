# Day 69 -- Ansible Playbooks and Modules
## TASK-1
1. Create install-nginx.yml:
```yaml
---
- name: Install and start Nginx on web servers
  hosts: worker-node-1
  become: true

  tasks:
    - name: Install Nginx
      dnf:
        name: nginx
        state: present

    - name: Start and enable Nginx
      service:
        name: nginx
        state: started
        enabled: true

    - name: Create a custom index page
      copy:
        content: "<h1>Deployed by Ansible - TerraWeek Server</h1>"
        dest: /usr/share/nginx/html/index.html
```

2. I run it:
```bash
ansible-playbook install-nginx.yml
```
Read the output carefully -- every task shows changed, ok, or failed.

Now i run it again. Notice that tasks show `ok` instead of `changed`. This is idempotency -- Ansible only makes changes when needed.

#### Verify: Curl the web server's public IP. Do you see your custom page?
* **YES!** i can see the custom page by using web server public IP.
![alt text](<Screenshot From 2026-11-10 16-40-00.png>)

## TASK-2

1. I Open my playbook and annotate each part in my notes:
```yaml
---                                                                     # YAML Document start
- name: Install and start Nginx on web servers                          # Name of the services
  hosts: worker-node-1                                                  # Define the inventory in which the playbook/task done
  become: true                                                          # Allow to run tasks as root(sudo)

  tasks:                                                                # List of tasks in the playbook
    - name: Install Nginx                                               # Name of the task
      dnf:                                                              # Package installer for OS
        name: nginx                                                     # Service Name
        state: present                                                  # State of Service

    - name: Start and enable Nginx                                      # Name of the Task
      service:                                                          # Service Defined
        name: nginx                                                     # Service Name
        state: started                                                  # State of the Service
        enabled: true                                                   # Command to start the Service forcefully if not started

    - name: Create a custom index page                                  # Name of the Task
      copy:                                                             # Command to copy the content below in the task
        content: "<h1>Deployed by Ansible - TerraWeek Server</h1>"      # Content to be copied
        dest: /usr/share/nginx/html/index.html                          # Destination where Content will copied
```

#### What is the difference between a play and a task?
* **Play** is the overall mapping that connects a specific group of servers to a general goal, while a **Task** is an individual step or command executed to achieve that goal.

#### Can you have multiple plays in one playbook?
* **YES!** we can have multiple plays in one playbook 

#### What does become: true do at the play level vs the task level?
* **Play level:** Applying `become: true` at the top of the play forces every single task inside that play to execute with administrative (sudo/root) privileges.
* **Task Level:** Overrides or activates privilege escalation for that specific task only. This is ideal when most actions can run as a standard guest user, but one specific step (like installing a package) needs admin authority.

#### What happens if a task fails -- do remaining tasks still run?
* Other servers keep running: If worker-node-1 fails, worker-node-2 will still continue executing its tasks normally.

## TASK-3
practice each of these modules by writing a playbook called essential-modules.yml with multiple tasks:

1. **`dnf`** -- Install and remove packages:
```yaml
- name: Install multiple packages
  dnf:
    name:
      - git
      - curl
      - wget
      - tree
      - nginx
    state: present
```

2. **`service`** -- Manage services:
```yaml
- name: Ensure Nginx is running
  service:
    name: nginx
    state: started
    enabled: true
```

3. **`copy`** -- Copy files from control node to managed nodes:
```yaml
- name: Copy config file
  copy:
    src: files/app.conf
    dest: /etc/app.conf
    owner: root
    group: root
    mode: '0644'
```

4. **`file`** -- Create directories and manage permissions:
```yaml
- name: Create application directory
  file:
    path: /opt/myapp
    state: directory
    owner: ec2-user
    mode: '0755'
```

5. **`command`** -- Run a command (no shell features):
```yaml
- name: Check disk space
  command: df -h
  register: disk_output

- name: Print disk space
  debug:
    var: disk_output.stdout_lines
```

6. **`shell'** -- Run a command with shell features (pipes, redirects):
```yaml
- name: Count running processes
  shell: ps aux | wc -l
  register: process_count

- name: Show process count
  debug:
    msg: "Total processes: {{ process_count.stdout }}"
```

7. **`lineinfile`** -- Add or modify a single line in a file:
```yaml
- name: Set timezone in environment
  lineinfile:
    path: /etc/environment
    line: 'TZ=Asia/Kolkata'
    create: true
```
8. I create a `files/` directory with a sample app.conf file for the copy task. Run the playbook against all servers.

#### What is the difference between command and shell? When should you use each?
* **command:** it runs commands directly through the system kernel but it didn't support linux terminal features like:- **((`|`) , (`>`) , (`$`) , (`*`))**
* **shell:** it supports terminal features like:- **((`|`) , (`>`) , (`$`) , (`*`))**

## TASK-4
1. Create nginx-config.yml:
```yaml
---
- name: Configure Nginx with a custom config
  hosts: worker-node-1
  become: true

  tasks:
    - name: Install Nginx
      yum:
        name: nginx
        state: present

    - name: Deploy Nginx config
      copy:
        src: /home/ubuntu/files/nginx.conf
        dest: /etc/nginx/nginx.conf
        owner: root
        mode: '0644'
      notify: Restart Nginx

    - name: Deploy custom index page
      copy:
        content: "<h1>Managed by Ansible</h1><p>Server: {{ inventory_hostname }}</p>"
        dest: /usr/share/nginx/html/index.html

    - name: Ensure Nginx is running
      service:
        name: nginx
        state: started
        enabled: true

  handlers:
    - name: Restart Nginx
      service:
        name: nginx
        state: restarted
```

2. I create `files/nginx.conf` with a basic Nginx config.
3. Run the playbook:
    First run: handler triggers because the config file is new
    Second run: handler does NOT trigger because nothing changed

#### Verify: Run it twice and compare the output. Does the handler run both times?
* **YES!** both handler runs both time

## TASK-5
Before running playbooks on production, always preview changes first.

1. **Dry run (check mode)** -- shows what would change without changing anything:
```bash
ansible-playbook install-nginx.yml --check
```
    
![alt text](<Screenshot From 2026-11-10 20-49-10.png>)

2. **Diff mode** -- shows the actual file differences:
```bash
ansible-playbook nginx-config.yml --check --diff
```

3. **Verbosity** -- increase output detail for debugging:
```bash
ansible-playbook install-nginx.yml -v       # verbose
ansible-playbook install-nginx.yml -vv      # more verbose
ansible-playbook install-nginx.yml -vvv     # connection debugging
```

4. **Limit to specific hosts:**
```bash
ansible-playbook install-nginx.yml --limit web-server
```
 
5. **List what should be affected without running**
```bash
ansible-playbook install-nginx.yml --list-hosts
ansible-playbook install-nginx.yml --list-tasks
```
#### Why is --check --diff the most important flag combination for production use?
* **`--check`** **`--diff`** acts as a zero-risk safety preview, showing the exact line-by-line changes a playbook will make without touching your live servers

## TASK-6
1. I Write **"multi-play.yml"** with separate plays for each server group:
```yaml
---
- name: Configure web servers
  hosts: worker-node-1
  become: true
  tasks:
    - name: Install Nginx
      dnf:
        name: nginx
        state: present
    - name: Start Nginx
      service:
        name: nginx
        state: started
        enabled: true

- name: Configure app servers
  hosts: worker-node-1
  become: true
  tasks:
    - name: Install Node.js dependencies
      dnf:
        name:
          - gcc
          - make
        state: present
    - name: Create app directory
      file:
        path: /opt/app
        state: directory
        mode: '0755'

- name: Configure database servers
  hosts: worker-node-1
  become: true
  tasks:
    - name: Install MySQL client
      dnf:
        name: mariadb
        state: present
    - name: Create data directory
      file:
        path: /var/lib/appdata
        state: directory
        mode: '0700'
```
2. I run it:
```bash
ansible-playbook multi-play.yml
```

Watch the output -- each play targets a different group, and tasks run only on the relevant hosts.
#### Verify: Is Nginx only installed on worker-node-1 servers? Is MySQL/MariaDB only on worker-node-1 servers?
* **YES!** Nginx and Mysql both installed in worker-node-1 sucessfull