# Test app

## Installing
```sh
poetry install
```

## Running
```sh
poetry run uvicorn --factory test_app:create_app
```

## Testing
```sh
poetry run pytest tests/unit
```