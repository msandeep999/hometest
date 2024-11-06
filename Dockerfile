# Use a Node.js base image
FROM node:16

# Set the working directory inside the container
WORKDIR /app

# Copy the package.json and install dependencies
COPY package.json /app
RUN npm install

# Copy the rest of the application code
COPY . /app

# Expose the port that the app will run on
EXPOSE 80

# Run the app
CMD ["npm", "start"]
