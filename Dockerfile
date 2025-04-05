FROM node:16
# Creating workdir with name app
RUN mkdir app
# Making the app folder as the work directory 
WORKDIR /app
# Copying the all package.json files and package-lock.json to the container folder 
COPY package*.json ./
# Installing the all dependencies
RUN npm install 
# Copying all files to the containers
COPY . .
# Build the react app
RUN npm  build

# React app port number
EXPOSE 3000
# Starting the React app  
CMD [ "npm" ,"start"]

