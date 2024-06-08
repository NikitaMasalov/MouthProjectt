import mysql.connector
from PIL import Image
import io

def image_to_binary(image_path):
    with open(image_path, 'rb') as img_file:
        binary_data = img_file.read()
    return binary_data

def insert_product(name, price, description, amount, weight, restaurant_id, photo_binary):
    # Подключение к базе данных
    db = mysql.connector.connect(
        host="localhost",
        port="3300",
        user="root",
        password="",
        database="mydb"
    )

    cursor = db.cursor()

    # SQL-запрос для вставки данных
    sql = """
    INSERT INTO product (name, price, description, amount, weight, restaurant_id, photo)
    VALUES (%s, %s, %s, %s, %s, %s, %s)
    """
    data = (name, price, description, amount, weight, restaurant_id, photo_binary)

    try:
        # Выполнение запроса
        cursor.execute(sql, data)
        db.commit()
        print("Product inserted successfully.")
    except mysql.connector.Error as err:
        print(f"Error: {err}")
        db.rollback()
    finally:
        # Закрытие соединения
        cursor.close()
        db.close()

# Пример использования
image_path = 'C:/Users/Professional/PycharmProjects/MouthProject/images (2).jpg'  # Замените на путь к вашему изображению
photo_binary = image_to_binary(image_path)

insert_product(
    name='Чизбургер',
    price=9.99,
    description='Вкусный чизбургер сделанный из мяса и мяса',
    amount=10,
    weight=1.5,
    restaurant_id=2,
    photo_binary=photo_binary
)