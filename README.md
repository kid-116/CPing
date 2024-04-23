[![API Tests](https://github.com/kid-116/CPing/actions/workflows/pytest.yml/badge.svg)](https://github.com/kid-116/CPing/actions/workflows/pytest.yml)
[![Flask Lint](https://github.com/kid-116/CPing/actions/workflows/pylint.yml/badge.svg)](https://github.com/kid-116/CPing/actions/workflows/pylint.yml)

# CPing
An app to remind you of upcoming coding contests.

> **Note** <br />
> Currently, signing up presents up with a warning about the app may not being safe as we haven't had the verified yet. But, we assure you that the app is not harmful and us and a few of our friends use to regularly without any problems. We'll be starting with the verification process as soon as possible.

## Features
- Google Sign-In
- Google Calendar API integration
- Supports
    - CodeForces
    - AtCoder
    - CodeChef

## Setup
### API
- Execute `pip install -r ./requirements.txt` to install associated libraries
- Download the file `api/key.json` from `Firebase` console for cache access
- Install `google-chrome` and a compatible `chromedriver`
- Edit the `executable_path` for `chromedriver` in `api/helpers/scrape.py` if necessary
- `flask run` 

### App
#### Generate Keys
```bash
cd android/app

keytool -genkey -v -keystore release-key.keystore -dname "cn=<cn>, ou=<ou>, o=<o>, c=<c>" -alias key-alias -keypass <keypass> -storepass <storepass> -validity 10000 -keyalg RSA -keysize 2048
```
#### Add Keys
`android/gradle.properties`
```
...
RELEASE_STORE_PASSWORD=<storepass>
RELEASE_KEY_PASSWORD=<keypass>
```

## Roadmap
- [ ] Setup Firebase Securtiy
- [ ] Release on PlayStore

## Links
- [Figma UI](https://www.figma.com/file/TmXK9ZfIX91RZlwguX4O7N/CPing)

## Troubleshooting
- Take care to use compatible versions for `google-chrome` and `chromedriver`. Refer [this](https://stackoverflow.com/a/55266105/15333904) answer on StackOverflow.