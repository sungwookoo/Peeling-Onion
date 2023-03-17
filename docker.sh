INTERNAL_PORT = 8080

if [[ "$JOB_NAME" == "user-prod" ]]; then
	EXTERNAL_PORT=10080
fi
if [[ "$JOB_NAME" == "user-main" ]]; then
	EXTERNAL_PORT=10081
fi
if [[ "$JOB_NAME" == "auth-prod" ]]; then
	EXTERNAL_PORT=10180
fi
if [[ "$JOB_NAME" == "auth-main" ]]; then
	EXTERNAL_PORT=10181
fi
if [[ "$JOB_NAME" == "alarm-prod" ]]; then
	EXTERNAL_PORT=10280
fi
if [[ "$JOB_NAME" == "alarm-main" ]]; then
	EXTERNAL_PORT=10281
fi
if [[ "$JOB_NAME" == "biz-prod" ]]; then
	EXTERNAL_PORT=10380
fi
if [[ "$JOB_NAME" == "biz-main" ]]; then
	EXTERNAL_PORT=10381
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
docker run -it -d -p $EXTERNAL_PORT:$INTERNAL_PORT --name "$JOB_NAME" "$JOB_NAME"
echo "Execute run $JOB_NAME"

### jenkins Execute shell command
#chmod +x ./docker.sh
#./docker.sh