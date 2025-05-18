#Contains API Endpionts for Friends
#Handles all the CRUD operations for friends


from fastapi import APIRouter, Depends, HTTPException, status
from typing import List
from sqlalchemy.orm import Session

from .. import models, schemas, database

router = APIRouter(
    prefix="/friends",
    tags=["friends"]
)

# POST /friends/: Create a new friend
# Validates the request data
# Checks for email uniqueness
# Saves to database
# Returns the created friend with status 201
@router.post("/", response_model=schemas.Friend, status_code=status.HTTP_201_CREATED)
def create_friend(friend: schemas.FriendCreate, db: Session = Depends(database.get_db)):
    # Check if email exists
    db_friend = db.query(models.Friend).filter(models.Friend.email == friend.email).first()
    if db_friend:
        raise HTTPException(status_code=400, detail="Email already registered")
    
    # Create new friend
    new_friend = models.Friend(**friend.model_dump()) #friend.dict()
    db.add(new_friend)
    db.commit()
    db.refresh(new_friend)
    return new_friend

# GET /friends/: Retrieve all friends
# Supports pagination with skip/limit
# Returns a list of friends
@router.get("/", response_model=List[schemas.Friend])
def get_friends(skip: int = 0, limit: int = 100, db: Session = Depends(database.get_db)):
    friends = db.query(models.Friend).offset(skip).limit(limit).all()
    return friends

# GET /friends/{id}: Get a specific friend
# Returns 404 if not found
@router.get("/{friend_id}", response_model=schemas.Friend)
def get_friend(friend_id: int, db: Session = Depends(database.get_db)):
    friend = db.query(models.Friend).filter(models.Friend.id == friend_id).first()
    if friend is None:
        raise HTTPException(status_code=404, detail="Friend not found")
    return friend

# PUT /friends/{id}: Update a friend
# Partial updates with only provided fields
# Returns 404 if not found
@router.put("/{friend_id}", response_model=schemas.Friend)
def update_friend(friend_id: int, friend: schemas.FriendUpdate, db: Session = Depends(database.get_db)):
    db_friend = db.query(models.Friend).filter(models.Friend.id == friend_id).first()
    if db_friend is None:
        raise HTTPException(status_code=404, detail="Friend not found")
    
    update_data = friend.model_dump(exclude_unset=True)
    for key, value in update_data.items():
        setattr(db_friend, key, value)
    
    db.commit()
    db.refresh(db_friend)
    return db_friend

# DELETE /friends/{id}: Delete a friend
# Returns 204 No Content if successful
# Returns 404 if not found
@router.delete("/{friend_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_friend(friend_id: int, db: Session = Depends(database.get_db)):
    friend = db.query(models.Friend).filter(models.Friend.id == friend_id).first()
    if friend is None:
        raise HTTPException(status_code=404, detail="Friend not found")
    
    db.delete(friend)
    db.commit()
    return None
