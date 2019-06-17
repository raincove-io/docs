FROM node:12.3.1-alpine

WORKDIR /home
COPY package.json package-lock.json ./

COPY . /home
RUN npm install

ENTRYPOINT ["npm", "start"]

EXPOSE 3000
