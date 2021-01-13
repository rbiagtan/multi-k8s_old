docker build -t rbiagtan/multi-client:latest -t rbiagtan/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t rbiagtan/multi-server:latest -t rbiagtan/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t rbiagtan/multi-worker:latest -t rbiagtan/multi-worker:$SHA -f ./worker/Dockerfile ./worker
docker push rbiagtan/multi-client:latest
docker push rbiagtan/multi-server:latest
docker push rbiagtan/multi-worker:latest

docker push rbiagtan/multi-client:$SHA
docker push rbiagtan/multi-server:$SHA
docker push rbiagtan/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=rbiagtan/multi-server:$SHA
kubectl set image deployments/client-deployment client=rbiagtan/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=rbiagtan/multi-worker:$SHA