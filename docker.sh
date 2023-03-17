if (docker ps -a| grep "alarm-main"); then
	docker stop "alarm-main"
    docker rm "alarm-main"
    docker build -t "alarm-main" .
    echo "Execute stop -> rm -> build alarm-main"
else
	docker build -t "alarm-main" .
    echo "Execute build alarm-main"
fi
docker run -it -d -p 10281:8080 --name "alarm-main" "alarm-main"
echo "Execute run alarm-main"

#docker build -t "alarm-main" .
#if (docker ps | grep "alarm-main"); then docker stop "alarm-main"; fi
#docker run -it -d -p 10281:8080 --name "alarm-main" "alarm-main"
#echo "Run testproject"