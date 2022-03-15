FROM node:latest as BUILD_IMAGE
ENV DIR=/usr/src/fpserv
WORKDIR ${DIR}
COPY . .
RUN npm install && npm run build

FROM alpine as PROD_IMAGE