FROM node:latest AS app
WORKDIR /app
COPY ./package.json /app
RUN npm install 
COPY . .
RUN npm run build 

FROM nginx
COPY --from=app /app/build /usr/share/nginx/html
COPY --from=app /app/nginx.conf /etc/nginx/conf.d/default.conf

