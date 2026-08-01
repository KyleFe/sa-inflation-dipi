"""Sample unit test."""

from sa_inflation_dipi import __version__


def test_version() -> None:
    """Test package version is set."""
    assert __version__ == "0.1.0"
