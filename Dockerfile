# Stage 1: Build the React app
FROM node:16-alpine as build

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

ARG PORT
ENV PORT=$PORT

RUN npm run build

# Stage 2: Serve the built app
FROM node:16-alpine

RUN npm install -g serve

WORKDIR /app

COPY --from=build /app/build ./build

EXPOSE $PORT

CMD ["sh", "-c", "serve -s build -l $PORT"]
