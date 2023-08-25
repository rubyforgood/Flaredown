FROM node:14.21

# Force npm version 7
RUN npm i -g npm@7

WORKDIR /app

COPY package*.json bower.json .bowerrc .npmrc ./

RUN npm install

# May no be needed in future version of node
ENV OPENSSL_CONF=/dev/null

COPY . .

CMD ["npm", "start"]
