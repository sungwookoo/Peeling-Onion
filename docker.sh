if [[ "$JOB_NAME" == "user-prod" ]]; then
	PORT=10080
fi
if [[ "$JOB_NAME" == "user-main" ]]; then
	PORT=10081
fi
if [[ "$JOB_NAME" == "auth-prod" ]]; then
	PORT=10180
fi
if [[ "$JOB_NAME" == "auth-main" ]]; then
	PORT=10181
fi
if [[ "$JOB_NAME" == "alarm-prod" ]]; then
	PORT=10280
fi
if [[ "$JOB_NAME" == "alarm-main" ]]; then
	PORT=10281
fi
if [[ "$JOB_NAME" == "biz-prod" ]]; then
	PORT=10380
fi
if [[ "$JOB_NAME" == "biz-main" ]]; then
	PORT=10381
fi

if [ docker ps -a| grep "alarm-main" ]; then
	docker stop "alarm-main"
    docker rm "alarm-main"
    docker build -t "alarm-main" .
    echo "Execute stop -> rm -> build alarm-main"
else
	docker build -t "alarm-main" .
    echo "Execute build alarm-main"
fi
docker run -it -d -p $PORT:8080 --name "alarm-main" "alarm-main"
echo "Execute run alarm-main"

### jenkins Execute shell command
#chmod +x ./docker.sh
#./docker.sh