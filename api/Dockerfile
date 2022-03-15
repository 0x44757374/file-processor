FROM node:latest as BUILD_IMAGE
ENV DIR=/usr/src/fpserv
WORKDIR ${DIR}
COPY . .
RUN npm install && npm run build

FROM alpine as PROD_IMAGE
RUN apk add --update nodejs npm
ENV DIR=/usr/src/fpserv
WORKDIR ${DIR}
COPY --from=BUILD_IMAGE $DIR/prod/ $DIR
RUN touch .env && \
	printf "API_PORT=${API_PORT}\n" >> .env && \
	printf "API_COOKIE_SECRET=${API_COOKIE_SECRET}\n" >> .env && \
	printf "CACHE_PORT=${CACHE_PORT}\n" >> .env && \
	printf "CACHE_PASS=${CACHE_PASS}\n" >> .env && \
	printf "CACHE_HOST=${CACHE_HOST}\n" >> .env
CMD ["npm", "run", "serve"]
