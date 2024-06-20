### STAGE 1: Build ###
FROM node:lts-alpine AS build

# Définir le répertoire de travail
WORKDIR /src

# Copier les fichiers package.json et package-lock.json pour installer les dépendances
COPY package*.json ./

#### install angular cli
RUN npm install -g @angular/cli

# Installer les dépendances Angular
RUN npm install

# Copier le code source de l'application
COPY . .

# Construire l'application pour la production
RUN npm run build --prod

### STAGE 2: Run ###
FROM nginx:alpine

#### copy artifact build from the 'build environment'
COPY --from=build /src/dist/angular-deploy/browser /usr/share/nginx/html

#### copy nginx conf

COPY nginx.conf /etc/nginx/conf.d/default.conf

# Exposer le port 4200
EXPOSE 4200

#### don't know what this is, but seems cool and techy
CMD ["nginx", "-g", "daemon off;"]





### STAGE 1: Build ###
# FROM httpd:2.4

# #### install angular cli
# RUN npm install -g @angular/cli

# Copier les fichiers de build Angular dans le répertoire htdocs d'Apache
# COPY ./dist/angular-deploy/browser /usr/local/apache2/htdocs/

# Exposer le port 80
# EXPOSE 80

# #### make the 'app' folder the current working directory
# WORKDIR /src

# #### copy both 'package.json' and 'package-lock.json' (if available)
# COPY package*.json ./

# #### install angular cli
# RUN npm install -g @angular/cli

# RUN npm cache clean --force

# #### install project dependencies
# RUN npm install

# #### copy things
# COPY . .

# #### generate build --prod
# RUN npm run build --prod

# ### STAGE 2: Run ###
# FROM nginxinc/nginx-unprivileged

# # USER root
# # RUN touch /run/nginx.pid \
# #  && chown -R api-gatway:api-gatway /run/nginx.pid

# #### copy nginx conf
# #COPY nginx.conf /etc/nginx/nginx.conf

# #### copy artifact build from the 'build environment'
# COPY --from=build /src/dist/angular-deploy/browser /usr/share/nginx/html

# #### don't know what this is, but seems cool and techy
# CMD ["nginx", "-g", "daemon off;"]