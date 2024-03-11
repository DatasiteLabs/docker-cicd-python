import pytest

from fastapi.testclient import TestClient


@pytest.mark.parametrize(
    ("augend", "addend", "expectation"), [
        (1, 2, 3),
        (2, 2, 4),
    ]
)
def test_add_endpoint_actually_adds(test_client: TestClient, augend, addend, expectation):
    response = test_client.get(f"/add/{augend}/{addend}")
    assert response.status_code == 200
    assert response.json() == {
        "augend": augend,
        "addend": addend,
        "sum": expectation,
    }
