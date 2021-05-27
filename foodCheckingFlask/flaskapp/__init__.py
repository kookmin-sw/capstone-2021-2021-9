'''
식품 분류: 제품명을 네이버 쇼핑 API에 입력하여 제품 유형을 불러옴
'''

# Clova OCR
import requests
import uuid
import time
import json
import base64
import urllib.request
import openpyxl
import datetime
from datetime import timedelta
from flask import Flask
import pandas as pd
import firebase_admin
from firebase_admin import credentials, firestore
import pyrebase

app = Flask(__name__)
app.debug = True

cred = credentials.Certificate("./test-db-56a02-firebase-adminsdk-k5oye-8d48a74410.json")
firebase_admin.initialize_app(cred, {'storageBucket': 'test-db-56a02.appspot.com'})

@app.route('/')
def create_app():

    config = {
        "apiKey": "AIzaSyDi2m9Z1mgTroxLc1plqJyH8-_Gf6G74-4",
        "authDomain": "test-db-56a02.firebaseapp.com",
        "databaseURL": "https://test-db-56a02.firebaseio.com/",
        "projectID": "test-db-56a02",
        "storageBucket": "test-db-56a02.appspot.com",
        "messagingSenderId": "795852762175",
        "addId": "1:795852762175:web:0b1c3cd84be6c44076dc8a",
        "measurementId": "G-F0R2FJZT9D"
    }

    firebase = pyrebase.initialize_app(config)
    storage = firebase.storage()
    path_on_cloud = "receipt.jpg"
    storage.child(path_on_cloud).download("receipt.jpg")

    api_url = 'https://eb2d4e564180412f954fb063cab4dd74.apigw.ntruss.com/custom/v1/8817/2146ec66fc0afc1f046ae6b62726734a605584c4e5ceb14af3f120fd68d5ba78/document/receipt'
    secret_key = 'bFhrYUVqa0Vma1dGZWJPS3lGanBNbHBPWURJeFZ1bFc='
    image_file = 'receipt.jpg'  # 내장된 사진 사용

    with open(image_file, 'rb') as f:
        file_data = f.read()

    request_json = {
        'images': [
            {
                'format': 'jpg',
                'name': 'demo',
                'data': base64.b64encode(file_data).decode()
            }
        ],
        'requestId': str(uuid.uuid4()),
        'version': 'V2',
        'timestamp': int(round(time.time() * 1000))
    }

    payload = json.dumps(request_json).encode('UTF-8')
    headers = {
        'X-OCR-SECRET': secret_key,
        'Content-Type': 'application/json'
    }

    response = requests.request("POST", api_url, headers=headers, data=payload)
    json_object = json.loads(response.text)
    receipt_text = json_object['images'][0]['receipt']['result']['subResults'][0]['items'][0]['name']['formatted'][
        'value']

    receipt_text_list = []
    for i in range(len(json_object['images'][0]['receipt']['result']['subResults'][0]['items'])):
        receipt_text_list.append(
            json_object['images'][0]['receipt']['result']['subResults'][0]['items'][i]['name']['formatted']['value'])
        if receipt_text_list[i][0].isalnum() is not True:
            receipt_text_list[i] = receipt_text_list[i][1:]

    # 네이버 쇼핑 api
    client_id = 'oo2ejX5_w6Hb8yOrk6Lu'  # My client_id
    client_secret = '_KmuzYVdyS'  # My client_secret

    receipt_category_list = []
    for j in range(len(receipt_text_list)):
        encText = urllib.parse.quote(receipt_text_list[j])  # 검색할 단어(위에서 받은 영수증 목록)
        url = 'https://openapi.naver.com/v1/search/shop?query=' + encText + '&start=1&display=1'
        request = urllib.request.Request(url)
        request.add_header('X-Naver-Client-Id', client_id)
        request.add_header('X-Naver-Client-Secret', client_secret)

        response = urllib.request.urlopen(request)
        one_result = json.loads(response.read().decode('utf-8'))
        if one_result['total'] != 0:
            receipt_category_list.append(one_result['items'][0]['category3'])
        else:
            receipt_category_list.append(' ')

    # 식품 분류 카테고리와 유통기한을 엑셀 파일에서 불러옴
    filename = "FoodCategory.xlsx"
    book = openpyxl.load_workbook(filename)
    sheet = book.worksheets[0]
    food_category = []
    expiration_date = []
    for row in sheet.rows:
        food_category.append(row[2].value)
        expiration_date.append(row[3].value)

    food_list = []
    food_type = []
    for k in range(len(receipt_category_list)):
        if receipt_category_list[k] in food_category:
            food_list.append(receipt_text_list[k])
            food_type.append(receipt_category_list[k])

    today_date = datetime.datetime.today().date()
    food_expiration_date = []
    for p in range(len(receipt_text_list)):
        if expiration_date[p] is not None:
            food_expiration_date.append(today_date + timedelta(days=int(expiration_date[p])))
        else:
            food_expiration_date.append(' ')

    # json 파일에 food_list, food_expiration_date 저장
    food_data = {}
    foods = []
    for i in range(len(food_list)):
        foods.append({"ExpirationDate": food_expiration_date[i].strftime('%Y-%m-%d'), "Name": food_list[i]})
    food_data["foods"] = foods

    print(food_data)

    with open("FoodList.json", "w") as json_file:
        json.dump(food_data, json_file, indent=4, sort_keys=True, default=str)

    db = firestore.client()
    doc_ref = db.collection(u'food')
    # Import data
    df = pd.read_json('FoodList.json')
    tmp = df.to_dict(orient='records')
    list(map(lambda x: doc_ref.add(x), tmp))

    return food_data
