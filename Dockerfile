# Build stage
FROM node:12-alpine as build-stage
WORKDIR /app
COPY package*.json ./
COPY . .
RUN npm install && npm run build

# Production stage
FROM nginx:alpine
WORKDIR /usr/share/nginx/html
COPY --from=build-stage /app/dist/ .
COPY nginx.conf /etc/nginx/conf.d/
EXPOSE 80
