FROM node:14.21

# Force npm version 7
RUN npm i -g npm@7

WORKDIR /app

COPY package*.json bower.json .bowerrc .npmrc ./

RUN npm install

COPY . .

CMD ["npm", "start"]
