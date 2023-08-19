FROM node:12.22.6

# Force npm version 7
RUN npm i -g npm@7

WORKDIR /app

COPY package*.json node_modules bower.json .bowerrc .npmrc ./

RUN npm install

COPY . .

# Rebuild node-sass for the current environment
RUN npm rebuild node-sass

CMD ["npm", "start"]
