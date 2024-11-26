# Step 1: Use an official Node.js image to build the app
FROM node:latest AS build


WORKDIR /app

# Copy package.json and package-lock.json for npm install
COPY package*.json ./

# Install the dependencies
RUN npm install

RUN npm install -g @angular/cli

# Copy the rest of the application code
COPY . .

# Build the Angular app in production mode
RUN npm run build 

# Step 2: Use an Nginx image to serve the app
FROM nginx:latest

COPY ./nginx.conf /etc/nginx/conf.d/default.conf

RUN rm -rf /usr/share/nginx/html/*

# Copy the built Angular app to Nginx’s public folder
COPY --from=build /app/dist/docker-project/browser /usr/share/nginx/html

# Expose the port Nginx is running on
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]


