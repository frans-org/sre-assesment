[![Terraform](https://github.com/frans-org/sre-assesmet/actions/workflows/terraform.yml/badge.svg?branch=main)](https://github.com/frans-org/sre-assesmet/actions/workflows/terraform.yml)

# Sre-Assesment
The project uses docker to build an nginx application, deploys and runs it in a pod on kubernetes. The following are the files used to create the app

* Terraform files
* Docker file
* github action(cicd) file

## Supporting infrastructure

The infrastructure(terraform IAC) is composed of the this components

* backend bucket that holds terraform state
* IAM, service account access with the required permissions
* kubernetes deployment and loadbalancer to access the app
* container registry
* VPC network

## Build Steps

The build pipeline builds a docker image from Dockerfile and pushes the image to continer registry.


Github actions runs through the workflow

### setup image pull request
```
kubectl create secret docker-registry artifact-reg \
--docker-server=https://europe-docker.pkg.dev \
--docker-email=project-service-account@*********.iam.gserviceaccount.com \
--docker-username=_json_key \
--docker-password="$(cat conf.json)"
```


## local testing
1. Base directory
   `` cd ~/``

2. Setup working directory, cd into directory
   ``` 
   $ mkdir docker-nginx-demo
   $ cd docker-nginx-demo
   ```
   

3. Create the Docker & Docker Compose configuration
    ```
    $ touch docker-compose.yaml
    ```

4. Edit your Docker Compose configuration file
    ```
    $ vim docker-compose.yaml
    ```
    
    

```
version: "3"
services:
    client:
    # Path to dockerfile.
    # '.' represents the current directory in which
    # docker-compose.yml is present.

        build: .
    # Mapping of container port to host
        ports:
            - 8000:80
        volumes:
            - ./index.html:/usr/share/nginx/html
```

5. Start the server

    ```
    $ docker-compose up --detach
    ```

    `docker-compose up`: This command does the work of the `docker-compose build` and `docker-compose run` commands.

6. Open web browser & see the result or use curl

   ``` http://localhost:8080/```
