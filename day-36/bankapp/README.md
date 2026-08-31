# Bank App
## What it does?
 **bankapp is a simple full‑stack banking application built with Flask that lets users register, log in, manage accounts, and perform transactions like deposits, withdrawals, and transfers. Admin (root) users get extra privileges such as creating, updating, or deleting accounts.**

### It is an basic test app for testing and creating dockerfile, with a basic simple create, add, withdraw and trasfer feature(CORE FEATURES)
* It takes account number to be created as input then create an account with that given input.
* We can simply add/deposit money by input which shows in balance.
* Tranfer money to one account to another in just three simple steps.
* We can simply check balance, shows how much money you have in  your account.
* We can check account history like: money deposit, withdraw, credited, debited etc.

### Admin (Root User) Privileges
* Create account → Add new customer accounts.
* Update account → Modify customer details or balances.
* Delete account → Remove accounts from the system.
* Create transactions → Perform deposits/withdrawals on behalf of use.

## How to run it with Docker Compose?
* Clone repository in your local
    - `git clone git@github.com:AlfaizMansoor/bankapp.git`
* Open cloned repo then build image through **"docker-compose.yml"** by using command in your terminal
    - `docker-compose up --build`
- Wait until images builds and run this will takes a few minutes.
* Once images build and containers running, check the running stage of containers by using command.
    - `docker ps`
* Run **"bankapp"** container on browser with this link on port 5000:
    - <http://localhost:5000>

* **There you'll see the home page of Flash bank app and test.**

## Any environment variables needed
* All environments needed is located in `.env` file 
    - MYSQL_ROOT_PASSWORD=rootpass
    - MYSQL_DATABASE=bankdb
    - MYSQL_USER=bankuser
    - MYSQL_PASSWORD=bankpass
    - DB_HOST=db
    - DB_PORT=3306
- **"you can change the value of environment varaiables according to you in .env file"**
