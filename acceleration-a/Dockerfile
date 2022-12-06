FROM node:10-alpine

WORKDIR /app

COPY . .

RUN yarn install && yarn build

EXPOSE 3002

ENTRYPOINT [ "yarn", "start" ]
