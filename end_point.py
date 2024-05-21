import json
from typing import Union
from fastapi import FastAPI, HTTPException, Response
from fastapi.staticfiles import StaticFiles
from fastapi import Depends, Request
from pydantic import BaseModel
from fastapi.responses import HTMLResponse, FileResponse
from fastapi.templating import Jinja2Templates
from fastapi_login.exceptions import InvalidCredentialsException
from fastapi_login import LoginManager
import os
from fastapi.middleware.cors import CORSMiddleware
import mysql.connector

app = FastAPI()
app.mount("/static", StaticFiles(directory="static"), name="static")

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
templates = Jinja2Templates(directory=".")

class User(BaseModel):
    pwd: str
    user: str

def connecttodb(nome):
    try:
        connection = mysql.connector.connect(
            host="localhost",
            user="root",
            password="",
            database=nome
        )
        print("Connessione al database MySQL avvenuta con successo!")
        return connection
    except mysql.connector.Error as err:
        print(f"Errore durante la connessione al database MySQL: {err}")
        return None

@app.route('/registra', methods=['GET', 'POST'])
async def registrazione(request: Request):
    if request.method == 'GET':
        with open("registra.html") as file:
            contenuto = file.read()
        
        return HTMLResponse(content=contenuto, status_code=200)
    
    elif request.method == 'POST':
        data = await request.json()
        first_name = data.get('first_name')
        last_name = data.get('last_name')
        email = data.get('email')
        password = data.get('password')
        
        connection = connecttodb('areapersonale')
        if connection is None:
            raise HTTPException(status_code=500, detail="Errore nella connessione al database")

        try:
            cursor = connection.cursor()
            # Esegui l'inserimento dei dati nel database
            query = "INSERT INTO utenti (nome, cognome, username, passwrd) VALUES (%s, %s, %s, %s)"
            data = (first_name, last_name, email, password)
            cursor.execute(query, data)
            # Esegui il commit delle modifiche
            connection.commit()
            return '{"message": "User registered successfully"}'
        except mysql.connector.Error as err:
            print(f"Errore durante l'esecuzione della query: {err}")
            raise HTTPException(status_code=500, detail="Errore durante l'esecuzione della query")
        finally:
            cursor.close()
            connection.close()

@app.route('/login', methods=['GET', 'POST'])
async def radice(request: Request):
    if request.method == 'GET':
        with open("login.html") as file: 
            contenuto = file.read()

        return HTMLResponse(content=contenuto, status_code=200)
   
    elif request.method == 'POST':
        data = await request.json()
        username = data.get('username')
        password = data.get('password')

        connection = connecttodb('areapersonale')
        if connection is None:
            raise HTTPException(status_code=500, detail="Errore nella connessione al database")
        
        try:
            cursor = connection.cursor(dictionary=True)
            query = "SELECT * FROM utenti WHERE username = %s AND passwrd = %s"
            print(query)
            cursor.execute(query, (username, password))
            user = cursor.fetchone()
            if user:
                # Utente trovato nel database, reindirizza alla pagina di 
                access_token = manager.create_access_token(data=dict(sub=username))
                response = HTMLResponse(content='<h1>Login effettuato correttamente!</h1>', status_code=200)
                manager.set_cookie(response, access_token)  # setta l'acces token come cookie
                return response
            else:
                # Credenziali non valide, reindirizza alla pagina di errore
                return HTMLResponse(content='<h1>Errore nel login.</h1>', status_code=401)
        except mysql.connector.Error as err:
            print(f"Errore durante l'esecuzione della query: {err}")
            raise HTTPException(status_code=500, detail="Errore durante l'esecuzione della query")
        finally:
            if cursor is not None:
                cursor.close()
            if connection is not None:
                connection.close()  


@manager.user_loader()
def load_user(user: str):  # Modifica qui il tipo di input
    connection = connecttodb('areapersonale') 
    cursor = connection.cursor(dictionary=True)
    cursor.execute("SELECT username, passwrd FROM utenti WHERE username = %s", (user,))  # Utilizza user direttamente
    user_data = cursor.fetchone()
    cursor.close()
    connection.close()
    
    return user_data  # Restituisce i dati dell'utente trovato

@app.get('/home', response_class=HTMLResponse)
def home(request: Request, user = Depends(manager)):
    # Connessione al database
    connection = connecttodb('supermercato')
    if connection is None:
        raise HTTPException(status_code=500, detail="Errore nella connessione al database")
    
    try:
        cursor = connection.cursor(dictionary=True)
        query = "SELECT id_i, nome, desc_prod, prezzo, immagine FROM item"
        cursor.execute(query)
        products = cursor.fetchall()
    except mysql.connector.Error as err:
        print(f"Errore durante l'esecuzione della query: {err}")
        raise HTTPException(status_code=500, detail="Errore durante l'esecuzione della query")
    finally:
        cursor.close()
        connection.close()

    return templates.TemplateResponse("home.html", {"request": request, "items": products})
    
@app.route("/richiesta", methods=['GET', 'POST'])
async def radice(request: Request, user = Depends(manager)):
    if request.method == 'GET':
        with open("richiesta.html") as file: 
            contenuto = file.read()

        return HTMLResponse(content=contenuto, status_code=200)


    elif request.method == 'POST':
        data = await request.json()
        testo = data.get('request')

        # Connessione al database
        connection = connecttodb('areapersonale')
        if connection is None:
            return {"message": "Errore nella connessione al database"}

        try:
            cursor = connection.cursor()
            # Esegui l'inserimento dei dati nel database
            query = "INSERT INTO richieste (testo) VALUES (%s)"
            cursor.execute(query, (testo,))
            # Esegui il commit delle modifiche
            connection.commit()
            return {"message": "Richiesta salvata con successo nel database"}
        except mysql.connector.Error as err:
            print(f"Errore durante l'esecuzione della query: {err}")
            return {"message": "Errore durante l'esecuzione della query"}
        finally:
            cursor.close()
            connection.close()
            
@app.get('/carrello')
async def carrello(request: Request, user: User = Depends(manager)):
        print(f"Tipo di user: {type(user)}")
        print(f"Contenuto di user: {user}")
        # Recupera i prodotti presenti nel carrello dell'utente
        connection = connecttodb('supermercato')
        if connection is None:
            raise HTTPException(status_code=500, detail="Errore nella connessione al database")

        try:
            cursor = connection.cursor(dictionary=True)
            query = """
            SELECT i.nome, i.prezzo, r.quantita
            FROM riga r
            INNER JOIN item i ON r.cod_i = i.id_i
            INNER JOIN carrello c ON r.cod_c = c.id_c
            WHERE c.username = %s
            """

            cursor.execute(query, (user['username'],))
            products_in_cart = cursor.fetchall()
        except mysql.connector.Error as err:
            print(f"Errore durante l'esecuzione della query: {err}")
            raise HTTPException(status_code=500, detail="Errore durante l'esecuzione della query")
        finally:
            cursor.close()
            connection.close()

        return templates.TemplateResponse("carrello.html", {"request": request, "products_in_cart": products_in_cart})
    
    
@app.post('/carrello')
async def carrello(request: Request, user: User = Depends(manager)):
    data = await request.json()
    product_id = data.get("product_id")
    user_id = user['username']

    connection = connecttodb('supermercato')
    if connection is None:
        raise HTTPException(status_code=500, detail="Errore nella connessione al database")

    try:
        cursor = connection.cursor(dictionary=True)

        # Controlla se l'utente ha già un carrello
        query = "SELECT id_c FROM carrello WHERE username = %s"
        cursor.execute(query, (user_id,))
        carrello = cursor.fetchone()

        # Se il carrello non esiste, creane uno nuovo
        if not carrello:
            insert_carrello = "INSERT INTO carrello (username) VALUES (%s)"
            cursor.execute(insert_carrello, (user_id,))
            connection.commit()
            carrello_id = cursor.lastrowid
        else:
            carrello_id = carrello['id_c']

        # Controlla se il prodotto è già nel carrello
        query = "SELECT id_r FROM riga WHERE cod_c = %s AND cod_i = %s"
        cursor.execute(query, (carrello_id, product_id))
        riga = cursor.fetchone()

        if riga:
            # Aggiorna la quantità del prodotto nel carrello
            update_riga = "UPDATE riga SET quantita = quantita + 1 WHERE id_r = %s"
            cursor.execute(update_riga, (riga['id_r'],))
        else:
            # Inserisci una nuova riga nel carrello
            insert_riga = "INSERT INTO riga (cod_c, cod_i, quantita) VALUES (%s, %s, 1)"
            cursor.execute(insert_riga, (carrello_id, product_id))

        connection.commit()

    except mysql.connector.Error as err:
        print(f"Errore durante l'esecuzione della query: {err}")
        raise HTTPException(status_code=500, detail="Errore durante l'esecuzione della query")
    finally:
        cursor.close()
        connection.close()

    return {"message": "Prodotto aggiunto al carrello"}

            
            
@app.get("/profilo")
def profilo(request: Request, user: User = Depends(manager)):
    # Connessione al database
    print(f"Tipo di user: {type(user)}")
    print(f"Contenuto di user: {user}")
    connection = connecttodb('AreaPersonale')
    if connection is None:
        raise HTTPException(status_code=500, detail="Errore nella connessione al database")
    
    try:
        cursor = connection.cursor(dictionary=True)
        query = "SELECT nome, cognome, username FROM utenti WHERE username= %s and passwrd= %s"
        cursor.execute(query,(user['username'], user['passwrd']))
        products = cursor.fetchone()
    except mysql.connector.Error as err:
        print(f"Errore durante l'esecuzione della query: {err}")
        raise HTTPException(status_code=500, detail="Errore durante l'esecuzione della query")
    finally:
        cursor.close()
        connection.close()

    return templates.TemplateResponse("profilo.html", {"request": request, "utente": products})

@app.route('/modifica', methods=['GET', 'POST'])
async def modifica(request: Request):
    if request.method == 'GET':
        with open("modifica_profilo.html") as file:
            contenuto = file.read()
        return HTMLResponse(content=contenuto, status_code=200)
