# CPing API Server

## Getting Started

### Setup
1. `cd` into `api` directory.
2. Create a python virtual environment.
3. Install dependencies.
    ```
    pip install -r requirements.txt
    ```
4. Install pre-commit hooks.
    ```
    pre-commit install
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
    ```
    docker run --rm cping_flask_api:dev
    ```

Similarly, the docker image may be built for other targets such as `test` and `prod`.
