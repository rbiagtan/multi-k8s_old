# Build images
docker build -t rbiagtan/multi-client:latest -t rbiagtan/multi-client:$SHA -f ./client/Dockerfile ./client # Note: $SHA is defined in .travis.yml
docker build -t rbiagtan/multi-server -f -t rbiagtan/multi-server:$SHA ./server/Dockerfile ./server
docker build -t rbiagtan/multi-worker -f -t rbiagtan/multi-worker:$SHA ./worker/Dockerfile ./worker

# Take each of the images and push them to Docker Hub
# Note: we had already logged into Docker Hub within the .travis.yml file
docker push rbiagtan/multi-client:latest
docker push rbiagtan/multi-server:latest
docker push rbiagtan/multi-worker:latest
docker push rbiagtan/multi-client:$SHA
docker push rbiagtan/multi-server:$SHA
docker push rbiagtan/multi-worker:$SHA

# Apply all configs in the 'k8s' folder
# In in the .travis.yml file, we had already kubectl cmd
# So just need to apply the config files
kubectl apply -f k8s

# Imperatively set latest images on each deployment
kubectl set image deployments/server-deployment server=rbiagtan/multi-server:$SHA
kubectl set image deployments/client-deployment client=rbiagtan/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=rbiagtan/multi-worker:$SHA