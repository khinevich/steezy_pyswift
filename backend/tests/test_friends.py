# tests/test_friends.py
from fastapi.testclient import TestClient
import uuid
from app.main import app

# Create test client
client = TestClient(app)

# Test data with unique email
unique_id = str(uuid.uuid4())[:8]  # Generate a random string for email
test_friend = {
    "name": "John",
    "surname": "Doe",
    "age": 30,
    "sex": "Male",
    "email": f"john.doe.{unique_id}@example.com",  # Unique email
    "telephone": "123-456-7890",
    "study": "Computer Science"
}

# Global variable to store created friend ID
created_friend_id = None

def test_root_endpoint():
    """Test the root endpoint returns a welcome message"""
    response = client.get("/")
    assert response.status_code == 200
    assert "message" in response.json()

def test_create_friend():
    """Test creating a new friend"""
    global created_friend_id
    
    response = client.post("/friends/", json=test_friend)
    
    assert response.status_code == 201
    data = response.json()
    assert data["name"] == test_friend["name"]
    assert data["email"] == test_friend["email"]
    assert "id" in data
    
    # Save the ID for other tests
    created_friend_id = data["id"]

def test_get_all_friends():
    """Test getting all friends"""
    response = client.get("/friends/")
    
    assert response.status_code == 200
    assert isinstance(response.json(), list)
    
    # If we've created a friend already, check it's in the list
    if created_friend_id:
        friend_ids = [f["id"] for f in response.json()]
        assert created_friend_id in friend_ids

def test_get_specific_friend():
    """Test getting a specific friend"""
    # Skip if we don't have a created friend
    if not created_friend_id:
        return  # Skip this test
    
    response = client.get(f"/friends/{created_friend_id}")
    
    assert response.status_code == 200
    data = response.json()
    assert data["id"] == created_friend_id
    assert data["name"] == test_friend["name"]

def test_update_friend():
    """Test updating a friend"""
    # Skip if we don't have a created friend
    if not created_friend_id:
        return  # Skip this test
    
    update_data = {
        "name": "Updated Name",
        "age": 31
    }
    
    response = client.put(f"/friends/{created_friend_id}", json=update_data)
    
    assert response.status_code == 200
    data = response.json()
    assert data["name"] == "Updated Name"
    assert data["age"] == 31
    assert data["surname"] == test_friend["surname"]  # Should be unchanged

def test_delete_friend():
    """Test deleting a friend"""
    # Skip if we don't have a created friend
    if not created_friend_id:
        return  # Skip this test
    
    response = client.delete(f"/friends/{created_friend_id}")
    assert response.status_code == 204
    
    # Verify the friend is gone
    get_response = client.get(f"/friends/{created_friend_id}")
    assert get_response.status_code == 404
