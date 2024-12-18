FROM node:14

WORKDIR /app

COPY backend/ ./backend
COPY frontend/ ./frontend
COPY .gitignore .

WORKDIR /app/backend/
RUN npm install

EXPOSE 3000

CMD ["node", "server.js"]