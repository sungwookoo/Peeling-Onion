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

if [[ $(docker ps -a | grep "$JOB_NAME") ]]; then
	docker stop "$JOB_NAME"
    docker rm "$JOB_NAME"
    docker build -t "$JOB_NAME" .
    echo "Execute stop -> rm -> build $JOB_NAME"
else
	docker build -t "$JOB_NAME" .
    echo "Execute build $JOB_NAME"
fi
docker run -it -d -p $PORT:8080 --name "$JOB_NAME" "$JOB_NAME"
echo "Execute run $JOB_NAME"

### jenkins Execute shell command
#chmod +x ./docker.sh
#./docker.sh