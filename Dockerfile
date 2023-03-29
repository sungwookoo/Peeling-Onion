# Node.js 이미지를 기반으로 새 이미지를 생성합니다.
FROM node:14

CMD ["ls"]

# 작업 디렉토리를 설정합니다.
WORKDIR /var/jenkins_home/workspace/react-main/peeling-onion

CMD ["ls"]

# 의존성 파일들을 컨테이너 안에 복사합니다.
COPY package*.json ./

# npm을 사용하여 패키지를 설치합니다.
RUN npm install

# 소스 코드를 컨테이너에 복사합니다.
COPY . .

# React 앱을 빌드합니다.
RUN npm run build

# 3000번 포트를 개방합니다.
EXPOSE 3000

# React 앱을 실행합니다.
CMD ["npm", "start"]
