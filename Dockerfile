FROM node:14

WORKDIR /app

COPY server/ ./server
COPY static/ ./static
COPY .gitignore .

WORKDIR /app/server/
RUN npm install

EXPOSE 3000

CMD ["node", "server.js"]