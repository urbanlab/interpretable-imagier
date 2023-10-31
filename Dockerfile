FROM node:lts as dev

WORKDIR /app

COPY src/ /app/src
COPY static/ /app/static
COPY .prettierignore /app/..prettierignore
COPY .prettierrc /app/.prettierrc
COPY package.json /app/package.json
COPY postcss.config.js /app/postcss.config.js
COPY svelte.config.js /app/svelte.config.js
COPY tailwind.config.js /app/tailwind.config.js
COPY tsconfig.json /app/tsconfig.json
COPY vite.config.ts /app/vite.config.ts

RUN npm install

EXPOSE 5173

ENTRYPOINT [ "npm", "run", "dev"]

FROM node:lts as build

WORKDIR /app

# copy node modules from dev stage
COPY --from=dev /app/ /app/

RUN npm run build

FROM nginx:alpine as prod

COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 80

ENTRYPOINT ["nginx", "-g", "daemon off;"]
