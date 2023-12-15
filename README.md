# 🎴 Interpretable Imagier
![Interpretable logo](static/logos/interpretable.png)

Interpretable is a communication tool using pictograms.
It was developed by the Erasme open innovation laboratory of the Metropole of Lyon.
For more information, visit https://erasme.org/interpretable.

Interpretable Imagier is a static web application that allows to manage the pictograms catalog by adding, editing and deleting pictograms and categories.

- [🎴 Interpretable Imagier](#-interpretable-imagier)
- [⚙️ Installation](#️-installation)
  - [🐋 Using Docker](#-using-docker)
    - [Use dev docker image](#use-dev-docker-image)
    - [Add a npm package using docker](#add-a-npm-package-using-docker)
    - [Build for production](#build-for-production)
  - [🟡 Using npm](#-using-npm)
    - [Install dependencies](#install-dependencies)
    - [Run the app in development mode](#run-the-app-in-development-mode)
    - [Build for production](#build-for-production-1)
  - [🗒 Configuration](#-configuration)
    - [Example of files](#example-of-files)
- [📄 License](#-license)


# ⚙️ Installation

## 🐋 Using Docker
### Use dev docker image
```
docker compose --profile dev  up -d
docker cp dev-interpretable-imagier:/app/node_modules ./
docker compose down

docker compose --profile dev up
```

### Add a npm package using docker
```
docker compose up -d
docker compose exec dev-interpretable-imagier npm install <package>
docker compose down
```
### Build for production

```
docker compose up -d
docker exec dev-interpretable-imagier npm run build
docker cp dev-interpretable-imagier:/app/build ./build
docker compose down
```

## 🟡 Using npm
### Install dependencies
```
npm install
```

### Run the app in development mode
```
npm start
```

### Build for production
```
npm run build
```

## 🗒 Configuration
To diplay the pictograms and categories, the app needs to load the folowing files:
- `static/svg` directory containing the pictograms svg files
- `static/main.csv` file containing the main categorie names and relations
- `static/category.csv` file containing the sub categorie names and relations to items (the pictograms)
- `static/items.csv` file containing the pictograms names and relations to categories

### Example of files

**`main.csv`**:

```
category_label,category_index
Accueil,6.1.0
```

**`category.csv`**:

```
category_label,category_index,,,,,,,,
Rendez-vous,6.1.0,,,,,,,,
```

**`items.csv`**:

```
pictogram_label,pictogram_file,pictogram_category,pictogram_metadata
J'ai rendez-vous,j_ai_rdv,6.1.0,rendez-vous;horaire;agenda;
```


This can be a little confusing to configure but the structure needed by the web app is more clear if you want to customize the app.

The app only need one json object structured as such:

```js 
{
    [
        {
            category_index: string,
            category_label: string,
            checked: boolean,
            sub_categorie_items: [
                {
                    category_index: string,
                    category_label: string,
                    checked: boolean,
                    items: [
                        {
                            pictogram_label: string,
                            pictogram_file: string
                        }
                    ]
                }
            ]

        }
    ]
}
```



# 📄 License
Interpretable Imagier is licensed under the [GNU Affero General Public License v3.0](LICENSE)