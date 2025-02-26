# Use Node.js as base image
FROM node:18-alpine as build

WORKDIR /app

# Copy package.json and install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy app source code
COPY . .

# Build the React app
RUN npm run build

# Use Nginx to serve the React app
FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]