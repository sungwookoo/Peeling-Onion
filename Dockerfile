FROM node:16.15.0 as build-stage
WORKDIR /var/jenkins_home/workspace/peeling_onion_react/peeling-onion
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build