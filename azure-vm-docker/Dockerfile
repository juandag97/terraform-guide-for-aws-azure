FROM node:20-lts-alpine

WORKDIR /app

COPY app/package.json ./
RUN npm install --production

COPY app/ ./

EXPOSE 8080

CMD ["node", "index.js"]
