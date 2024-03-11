from fastapi.testclient import TestClient

import pytest

from test_app import create_app

@pytest.fixture
def test_app():
    return create_app()

@pytest.fixture
def test_client(test_app):
    return TestClient(test_app)
