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

### Build and push
1. The build pipeline builds a docker image from Dockerfile. 
2. and pushes the image to continer registry.
3. Ensure the correct permissions are setup to allow github to authenticate with Google Cloud.
4. This can be done by creating credentials and adding them to github secrets e.g. ${{ secrets.GOOGLE_CREDENTIALS }}

### Deploy
1. Using terraform, the workflow will run a job that deploys the files needed to create the infrastructure
2. This includes the k8s manifest files that deploy the replica pods running the application containers
3. When the pod is initialised it pulls the image from the GCR registry, so its required that imagePullSecrets is setup
4. You can run the following commands to set this up.

### setup image pull secrets
```
kubectl create secret docker-registry artifact-reg \
--docker-server=https://europe-docker.pkg.dev \
--docker-email=project-service-account@*********.iam.gserviceaccount.com \
--docker-username=_json_key \
--docker-password="$(cat conf.json)"
```
5. You can edit the default service account
   
```
kubectl edit serviceaccount default --namespace default
```
6. Then add the newly created imagePullSecret secret

```
apiVersion: v1
kind: ServiceAccount
metadata:
  name: default
  namespace: default
  ...
imagePullSecrets:
- name: artifact-registry
```

## To test the app locally

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
