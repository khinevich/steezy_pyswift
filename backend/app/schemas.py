#Defines data validation and serialization
#Request and response validation

# These Pydantic models provide automatic validation, serialization, and documentation.
from pydantic import BaseModel
from typing import Optional

# Base schema with common fields
class FriendBase(BaseModel):
    name: str
    surname: str
    age: int
    sex: str
    email: str
    telephone: str
    study: str

# For validating new friend data (without ID)
class FriendCreate(FriendBase):
    pass

# For partial updates with optional fields
class FriendUpdate(BaseModel):
    name: Optional[str] = None
    surname: Optional[str] = None
    age: Optional[int] = None
    sex: Optional[str] = None
    email: Optional[str] = None
    telephone: Optional[str] = None
    study: Optional[str] = None

# Complete friend data with ID for responses
class Friend(FriendBase):
    id: int
    
    model_config = {
        "from_attributes": True
    }