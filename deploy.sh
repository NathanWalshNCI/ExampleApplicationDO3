#!/usr/bin/env bash
# Check if there is an running with the instance name we are deploying
CURRENT_INSTANCE=$(docker ps -a -q --filter ancestor="$IMAGE_NAME" --format="{{.ID}}")

# If an instance does exist stop the instance
if [ "$CURRENT_INSTANCE" ]
then
	docker rm $(docker stop $CURRENT_INSTANCE)
fi

# Pull down the instance from DockerHub
docker pull $IMAGE_NAME

# Check if a docker container exists with the name of the $CONTAINER_NAME. If it does remove the container
CONTAINER_EXISTS=$(docker ps -a | grep $CONTAINER_NAME) 
if [ "$CONTAINER_EXISTS" ]
then
	docker rm $CONTAINER_NAME
fi

# Create a container called $CONTAINER_NAME that is available on port 8443 from our docker image
docker create -p 8443:8443 --name $CONTAINER_NAME $IMAGE_NAME
# Write the private key to a file
echo $PRIVATE_KEY > privatekey.pem
# Write the server key to a file
echo $SERVER > server.crt
# Add the private key to the $CONTAINER_NAME docker container
docker cp ./privatekey.pem $CONTAINER_NAME:/privatekey.pem
# Add the server key to the $CONTAINER_NAME docker container
docker cp ./server.crt $CONTAINER_NAME:/server.crt
# Start the $CONTAINER_NAME container
docker start $CONTAINER_NAME


#sudo apt update && sudo apt install nodejs npm
#Install PM2 which is a production process manager for Node.js with a built-in load balancer.
#sudo npm install -g pm2
#Stop any instance of our application running currently
#pm2 stop example_app
#CD into folder where application is downloaded
#cd ExampleApplicationDO3/
#Install application dependencies
#npm install
#echo $PRIVATE_KEY > privatekey.pem
#echo $SERVER > server.crt
#Start the application with the process name example_app using PM2
#pm2 start ./bin/www --name example_app