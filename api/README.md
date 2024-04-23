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
