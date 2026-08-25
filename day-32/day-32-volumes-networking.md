# Day 32 – Docker Volumes & Networking
## TASK-1
#### Steps : 
1. Run a Postgres or MySQL container
2. Create some data inside it (a table, a few rows — anything)
3. Stop and remove the container
4. Run a new one — is your data still there?

- **NO!** My data is not there because custom volume(Local Volume) didn't attached to the container which saves the database.

## Task-2
#### Steps : 
1. Create a named volume
2. Run the same database container, but this time attach the volume to it
3. Add some data, stop and remove the container
4. Run a brand new container with the same volume
5. Is the data still there?

- **YES!** my data is still there because i attached custom volume from local.

## TASK-3 
#### Steps :
1. Create a folder on your host machine with an index.html file
2. Run an Nginx container and bind mount your folder to the Nginx web directory
3. Access the page in your browser
4. Edit the index.html on your host — refresh the browser

#### What is the difference between a named volume and a bind mount?
* Named volume → Docker creates and manages its own storage location. You just give it a name (like mydata), and Docker takes care of where it lives. It’s safe, portable, and good for keeping data even if containers are removed.
* Bind mount → You tell Docker exactly which folder or file from your computer to use inside the container. It’s great for development because changes on your computer show up instantly in the container, but it’s riskier and less portable.

## TASK-4 
#### Steps :
1. List all Docker networks on your machine
    - NETWORK ID    |  NAME  |   DRIVER   |  SCOPE
    - 53ac8e5d6e0e  | bridge |   bridge   |  local
    - dbceb718b674  | host   |    host    |  local
    - f8a2c67e6050  | none   |    null    |  local
2. Inspect the default bridge network
3. Run two containers on the default bridge — can they ping each other by name?
    - **NO!** they did not ping each other by name.
4. Run two containers on the default bridge — can they ping each other by IP?
    - **YES!** they ping each other by IP

## TASK-5 
#### Steps :
1. Create a custom bridge network called my-app-net
2. Run two containers on my-app-net
3. Can they ping each other by name now?
    - **YES!** now they ping each other by name

#### Why does custom networking allow name-based communication but the default bridge doesn't?
* On the default bridge, Docker does not run its DNS service. That means containers can only talk to each other using IP addresses, not names.

* On a custom bridge, Docker automatically enables its built‑in DNS. This DNS knows each container’s name and maps it to its IP, so containers can talk to each other by name.

## TASK-6
#### Steps :
1. Create a custom network
2. Run a database container (MySQL/Postgres) on that network with a volume for data
3. Run an app container (use any image) on the same network
4. Verify the app container can reach the database by container name

- **$** Verified! app container reaches database by only container name.