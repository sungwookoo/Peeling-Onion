FROM node:16.15.0 as build-stage
WORKDIR /var/jenkins_home/workspace/react-main/peeling-onion
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build