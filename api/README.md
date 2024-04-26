# CPing API Server

## Getting Started

### Setup
1. `cd` into `api` directory.
2. Create a python virtual environment.
3. Install dependencies.
    ```
    pip install -r requirements.txt
    ```
4. Authorize `gcloud` for the project.
    ```
    gcloud auth application-default login
    ```

### Running
1. Run the server (in debug mode).
    ```
    flask run --debug
    ```

## Development

### Linting
1. yapf
    ```
    yapf -i -r .
    ```

2. pylint
    ```
    pylint --recursive=y .
    ```

3. mypy
    ```
    mypy .
    ```

### Testing
1. Run tests.
    ```
    pytest
    ```

### Docker
1. Execute.
    ```
    export DOCKER_BUILDKIT=1
    ```

#### Development
1. Build image.
    ```
    cd api/
    docker build -t cping_flask_api:dev --target dev .
    ```
2. Run image.
- dev
    ```
    docker run --rm \
        -v ~/.config/gcloud:/root/.config/gcloud \
        cping_flask_api:dev
    ```
- test
    ```
    docker run --rm \
        -v ~/.config/gcloud:/root/.config/gcloud \
        --env-file .env \
        cping_flask_api:test
    ```
- prod
    ```
    docker run --rm -d \
        -v ~/.config/gcloud:/root/.config/gcloud \
        --env-file .env \
        -p 80:80 \
        cping_flask_api:prod
    ```

Similarly, the docker image may be built for other targets such as `test` and `prod`.
