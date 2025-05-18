# backend/run_tests.py
import pytest
import sys

if __name__ == "__main__":
    # Run tests and exit with appropriate status code
    #sys.exit(pytest.main(["-xvs", "tests/"]))
    pytest.main(["-xvs", "tests/"])