# Node.js 이미지를 기반으로 새 이미지를 생성합니다.
FROM node:16.15.0 as build-stage

# 작업 디렉토리를 설정합니다.
WORKDIR /var/jenkins_home/workspace/react-main/peeling-onion

# 의존성 파일들을 컨테이너 안에 복사합니다.
COPY package*.json ./

# npm을 사용하여 패키지를 설치합니다.
RUN npm install

# 소스 코드를 컨테이너에 복사합니다.
COPY . .

RUN npm run build
FROM nginx:stable-alpine as production-stage

COPY --from=build-stage /var/jenkins_home/workspace/react-main/peeling-onion/build /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g","daemon off;"]