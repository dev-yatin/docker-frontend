# Production Dockerfile
# In Dockerfile there can be only one FROM. If you want to use more than 1 FROM then you have to block that
# as I have done it. I have blocked by name builder. This will also help us to fetch resource from this 
#builder container in another container. NOTE this blocked container will not be part of actual image. 
# It just help us with pre-processing and providing resource in new container(Remember images are build 
#in form of incremental containers).
FROM node:current-alpine3.18 as builder
WORKDIR /app

COPY ./package.json .
RUN npm install

COPY . .
# Here build folder will get created
RUN npm run build

# Here we don't use block because this is going to be main part of our image
FROM nginx:alpine3.18
# Exposing port not required for us but AWS Elasticbeanstalk require it as it check dockerfile 
# and map host machine port with guest port.
EXPOSE 80
COPY --from=builder /app/build /usr/share/nginx/html





