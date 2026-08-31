# Day 36 – Docker Project: Dockerize a Full Application
## What app you chose and why
* I choose **"bankapp"** because this app is simple, small, easy to understand and i have only one app in my github. 
## Your Dockerfile (with comments explaining each line)
 ### This is a test Docker file to Dockerize a full Application
1. **# Pulling image from remote/local** 
    - `FROM python:3.11-slim`
2. **# Working directory defined in image**
    - `WORKDIR /app`
3. **# Running command and updating, installing dependencies and removing unneccasry files during building images**
    - `RUN apt-get update && apt-get install -y --no-install-recommends netcat-openbsd \`
	`&& rm -rf /var/lib/apt/lists/*`
4. **# Copying "requirements.txt" into the image**
    - `COPY requirements.txt ./`
5. **# Upgrading image and installing dependencies from "requirements.txt" file**
    - `RUN pip install --upgrade pip && \`
	    `pip install --no-cache-dir -r requirements.txt`
6. **# Adding a non-root user name 'bankemployee'**
    - `RUN useradd -m bankemployee` 
7. **# Copy files and folders from the location where 'Dockerfile' is located**
    - `COPY . .`
8. **# Copy "entrypoint.sh" from the same folder where 'Dockerfile' is loacted**
    - `COPY entrypoint.sh .`
9. **# Changing the permissions of copied "entrypoint.sh" file and ownership to a non-root user created at step-6**
    - `RUN chmod +x entrypoint.sh && chown -R bankemployee /app`
10. **# Defines user**
    - `USER bankemployee`
11. **# Defines port where the app should run**
    - `EXPOSE 5000`
12. **# Running "entrypoint.sh" after making image inside the image**
    - `CMD ["sh", "entrypoint.sh"]`

## Challenges you faced and how you solved them
* At first i was unable to install netcat because i can't find what it needs but later when i run it i got an error **"nc not found"** then search it on google and it recommends me the installation of nc
* Due to enhanced  and higher security i added hash system to secure it but unable to understand why it fails then i look at **'sha_password_crypt'** then i add crptography dependency in **"requirements.txt"**
* I copied **"entrypoint.sh"** but forget to change it's permission so i gave permission to this file during building image as a testing, and unfortunately it workd so i changed it's permission during build.
* `CMD ["sh", "entrypoint.sh"]` instead of this command i wrote `CMD ["python", "bank.py"]` i didn't get it why this not working then  later i added `CMD ["sh", "entrypoint.sh"]` but still container was not running because i have both `CMD ["sh", "entrypoint.sh"]` and `CMD ["python", "bank.py"]` in my **"Dockerfile"**
* After resolving all the errors from Dockerfile i build anf run the container but still its not running so after surfing for a few hours i check my **"bank.py"** and found out that:
- **Port declaration is missing**
    - `if __name__ == "__main__"`
    -    `app.run(host="0.0.0.0", port=5000, debug=True)` 

## Final image size
* Image size after pulling from Docker-Hub
- devuqaab/bankapp:v.1    |     62fb722c78b2   |    1.09GB      |    234MB    
- devuqaab/bankapp:v.2    |     cf2f5fbab962   |    283MB       |    68MB 

## Docker Hub link
- <https://hub.docker.com/repository/docker/devuqaab/bankapp/general> 
- <https://hub.docker.com/repository/docker/devuqaab/bankapp/tags/v.1/sha256-62fb722c78b24245ddff1796a0fcee4a49cc5b87e0aaaf20c92d1da9e0a2497b>
- <https://hub.docker.com/repository/docker/devuqaab/bankapp/tags/v.2/sha256-326a68825ddb6ea451fb42cc35adfc8f642e7eefbe74aa5ee709be3a64d871d8>