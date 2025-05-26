#Defines DB tables as Pyhton classes
from sqlalchemy import Column, Integer, String
from .database import Base

class Friend(Base):
    __tablename__ = "friends"
    #indexed columns are used for searching, faster queries
    #unique columns are used for ensuring that no two records have the same value
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True)
    surname = Column(String, index=True)
    age = Column(Integer)
    sex = Column(String)
    email = Column(String, unique=True, index=True)
    telephone = Column(String)
    study = Column(String)