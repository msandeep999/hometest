# Dockerfile

# Use Node.js version 16 as the base image
FROM node:16

# Create and set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to the container
COPY package.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code to the container
COPY . .

# Expose port 80 for the app
EXPOSE 80

# Start the application
CMD ["npm", "start"]
