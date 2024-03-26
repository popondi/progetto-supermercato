import json
from typing import Union
from fastapi import FastAPI, Response
from fastapi import Depends
from pydantic import BaseModel
from fastapi.responses import HTMLResponse, FileResponse
from fastapi_login.exceptions import InvalidCredentialsException
from fastapi_login import LoginManager
import os
from http import HTTPStatus as stat
import xml.etree.ElementTree as ET
from fastapi.middleware.cors import CORSMiddleware


app = FastAPI()
#https://fastapi-login.readthedocs.io/usage/
#https://pypi.org/project/fastapi-login/

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Consentire tutte le origini (o specifica le tue origini consentite)
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "DELETE"],  # Specifica i metodi HTTP consentiti
    allow_headers=["*"],  # Consentire tutti gli header nelle richieste
)


SECRET = os.urandom(24).hex()
manager = LoginManager(SECRET, '/login', use_cookie=True)
fake_db = [{"username": "admin", 'password': '1234'}]


class User(BaseModel):
    pwd: str
    user: str


@manager.user_loader()
def load_user(user: str):  # could also be an asynchronous function
    for u in fake_db:
        if u['username'] == user:
            return u


@app.get("/registra.css")
def radice():
    return FileResponse( '.\\registra.css', status_code=200)

@app.get("/login.css")
def radice():
    return FileResponse( '.\\login.css', status_code=200)

@app.get('/login', response_class=FileResponse)
def radice():
    with open("login.html") as file:
        contenuto = file.read()

    return HTMLResponse(content=contenuto, status_code=200)

@app.get('/', response_class=FileResponse)
def radice():
    with open("registra.html") as file:
        contenuto = file.read()

    return HTMLResponse(content=contenuto, status_code=200)


if __name__ =="__main__":
    from os import system as sys
    sys('cd')
    sys("python -m uvicorn server:app --reload")