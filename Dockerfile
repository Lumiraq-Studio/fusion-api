# Use official Node.js image as the base
FROM node:lts

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json (if exists)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application source code
# COPY /dist/. .
COPY . .

# Build the application
# To be removed when it's built in the CI/CD pipeline
RUN npm run build

# Expose the port your NestJS application listens on (e.g., 3000)
EXPOSE 3000

# Start the NestJS application using the compiled output
CMD ["npm", "run", "start:prod"]