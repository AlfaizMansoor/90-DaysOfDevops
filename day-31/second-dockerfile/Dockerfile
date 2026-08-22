# My Second Docker file

FROM nginx:alpine

WORKDIR /app

RUN apk update

COPY ./car.html /usr/share/nginx/html/index.html

CMD ["nginx", "-g", "daemon off;"]

EXPOSE 80

