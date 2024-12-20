"""Hello unit test module."""

from proj1.hello import hello


def test_hello():
    """Test the hello function."""
    assert hello() == "Hello proj1"
