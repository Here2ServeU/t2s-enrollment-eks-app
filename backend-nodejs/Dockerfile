# Use Node.js as base image
FROM node:18-alpine

WORKDIR /app

# Install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy app source code
COPY . .

EXPOSE 5000
CMD ["node", "server.js"]