FROM node:20.5.1-alpine3.17 AS build
WORKDIR /app
COPY . .

RUN npm install
RUN npm run build

# production stage
FROM nginx:1.25.1-alpine AS production
WORKDIR /usr/share/nginx/html
# Remove default nginx static assets
RUN rm -rf ./*
COPY --from=build /app/nginx.config /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html
CMD ["nginx", "-g", "daemon off;"]
