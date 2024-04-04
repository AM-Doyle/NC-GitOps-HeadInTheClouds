# Stage 1: Build the Node.js application
FROM node:20.10.0 as build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build


FROM nginx:1.21.0-alpine AS production

# Copy your entrypoint script into the container
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Copy the built source code from the first stage to the Nginx directory
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose the port that Nginx will listen on 
EXPOSE 80

# Define the command to start Nginx
CMD ["nginx", "-g", "daemon off;"]