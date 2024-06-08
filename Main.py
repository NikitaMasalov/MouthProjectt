import mysql.connector
import tkinter as tk
from tkinter import ttk
from PIL import Image, ImageTk
from passlib.hash import sha256_crypt
import io 

# Подключение к Mysql (Не забыть поменять порт!!!)
db = mysql.connector.connect(
    host="localhost",
    port="3300",
    user="root",
    password="",
    database="mydb"
)

cursor = db.cursor()
# отвечает за показать пароль уберать "*"
def toggle_password_visibility():
    if show_password.get():
        entry_password.config(show="")
    else:
        entry_password.config(show="*")

#Окно регестрации
def open_registration_window():
    registration_window = tk.Toplevel(root)
    registration_window.title("Регистрация")
    
    # Функция для регистрации
    def register_user():
        name = entry_name.get()
        surname = entry_surname.get()
        password = entry_password.get()
        password_confirm = entry_password_confirm.get()
        address = entry_address.get()
        number = entry_number.get()

        if not all([name, surname, password, password_confirm, address, number]):
            label_status.config(text="Все поля должны быть заполнены")
            return
        if password != password_confirm:
            label_status.config(text="Пароли не совпадают")
            return

        hashed_password = sha256_crypt.hash(password)

        sql = "INSERT INTO user (name, surname, password_hash, address, number) VALUES (%s, %s, %s, %s, %s)"
        values = (name, surname, hashed_password, address, number)
        cursor.execute(sql, values)
        db.commit()
        label_status.config(text="Пользователь зарегистрирован")

    registration_frame = tk.Frame(registration_window, bg='#FFFFFF', bd=2, relief=tk.RIDGE)
    registration_frame.pack(expand=True, fill='both')

    label_name = tk.Label(registration_frame, text="Имя:", bg='#FFFFFF', font=('Arial', 14))
    label_name.grid(row=0, column=0, pady=10, padx=10, sticky="e")
    entry_name = tk.Entry(registration_frame, font=('Arial', 12), bd=2, relief=tk.SOLID)
    entry_name.grid(row=0, column=1, pady=10, padx=10, sticky="w")

    label_surname = tk.Label(registration_frame, text="Фамилия:", bg='#FFFFFF', font=('Arial', 14))
    label_surname.grid(row=2, column=0, pady=10, padx=10, sticky="e")
    entry_surname = tk.Entry(registration_frame, font=('Arial', 12), bd=2, relief=tk.SOLID)
    entry_surname.grid(row=2, column=1, pady=10, padx=10, sticky="w")

    label_password = tk.Label(registration_frame, text="Пароль:", bg='#FFFFFF', font=('Arial', 14))
    label_password.grid(row=4, column=0, pady=10, padx=10, sticky="e")
    entry_password = tk.Entry(registration_frame, show="*", font=('Arial', 12), bd=2, relief=tk.SOLID)
    entry_password.grid(row=4, column=1, pady=10, padx=10, sticky="w")

    label_password_confirm = tk.Label(registration_frame, text="Повторите пароль:", bg='#FFFFFF', font=('Arial', 14))
    label_password_confirm.grid(row=6, column=0, pady=10, padx=10, sticky="e")
    entry_password_confirm = tk.Entry(registration_frame, show="*", font=('Arial', 12), bd=2, relief=tk.SOLID)
    entry_password_confirm.grid(row=6, column=1, pady=10, padx=10, sticky="w")


    label_address = tk.Label(registration_frame, text="Адрес:", bg='#FFFFFF', font=('Arial', 14))
    label_address.grid(row=0, column=2, pady=10, padx=10, sticky="e")
    entry_address = tk.Entry(registration_frame, font=('Arial', 12), bd=2, relief=tk.SOLID)
    entry_address.grid(row=0, column=3, pady=10, padx=10, sticky="w")

    label_number = tk.Label(registration_frame, text="Номер:", bg='#FFFFFF', font=('Arial', 14))
    label_number.grid(row=2, column=2, pady=10, padx=10, sticky="e")
    entry_number = tk.Entry(registration_frame, font=('Arial', 12), bd=2, relief=tk.SOLID)
    entry_number.grid(row=2, column=3, pady=10, padx=10, sticky="w")

    label_status = tk.Label(registration_frame, text="", bg='#FFFFFF', font=('Arial', 12))
    label_status.grid(row=8, columnspan=4, pady=10)

    button_register = tk.Button(registration_frame, text="Зарегистрироваться", font=('Arial', 12), command=register_user)
    button_register.grid(row=9, columnspan=4, pady=10)


# Функция для входа
def login_user():
    username = entry_username.get()
    password = entry_password.get()

    sql = "SELECT * FROM user WHERE name = %s"
    cursor.execute(sql, (username,))
    user = cursor.fetchone()

    if user:
        if sha256_crypt.verify(password, user[4]):  
            label_status.config(text="Вход выполнен успешно")
            open_delivery_viewing_window(user) 
        else:
            label_status.config(text="Неверный пароль")
    else:
        label_status.config(text="Пользователь не найден")

#Основное окно покупок
def open_delivery_viewing_window(logged_in_user):
    delivery_window = tk.Toplevel(root)
    delivery_window.title("Информация о продуктах")
  
    screen_width = root.winfo_screenwidth()
    screen_height = root.winfo_screenheight()
    delivery_window.geometry(f"{screen_width}x{screen_height}")

    search_frame = tk.Frame(delivery_window)
    search_frame.pack(fill=tk.X, padx=10, pady=10)

    category_label = tk.Label(search_frame, text="Категория:", font=('Arial', 12))
    category_label.pack(side=tk.LEFT, padx=5)
    category_entry = tk.Entry(search_frame, font=('Arial', 12), bd=2, relief=tk.SOLID)
    category_entry.pack(side=tk.LEFT, padx=5)

    search_label = tk.Label(search_frame, text="Поиск:", font=('Arial', 12))
    search_label.pack(side=tk.LEFT, padx=5)
    search_entry = tk.Entry(search_frame, font=('Arial', 12), bd=2, relief=tk.SOLID)
    search_entry.pack(side=tk.LEFT, padx=5)

    def search_by_category():
        category = category_entry.get()
        if category:
            cursor.execute("""SELECT product.id, product.name
                              FROM product
                              JOIN category_has_product ON product.id = category_has_product.product_id
                              JOIN category ON category_has_product.category_id = category.id
                              WHERE category.category = %s""", (category,))
            display_products(cursor.fetchall())
        else:
            display_products([])

    def search_products():
        search_term = search_entry.get()
        if search_term:
            cursor.execute("""SELECT id, name
                              FROM product
                              WHERE name LIKE %s OR description LIKE %s""", 
                           (f"%{search_term}%", f"%{search_term}%"))
            display_products(cursor.fetchall())
        else:
            display_products([])

    category_button = tk.Button(search_frame, text="Поиск по категории", command=search_by_category)
    category_button.pack(side=tk.LEFT, padx=5)

    search_button = tk.Button(search_frame, text="Поиск", command=search_products)
    search_button.pack(side=tk.LEFT, padx=5)

    separator_frame = tk.Frame(delivery_window, height=2, bd=1, relief=tk.SUNKEN, bg='#808080')
    separator_frame.pack(fill=tk.X, padx=10, pady=(0, 10))

    products_frame = tk.Frame(delivery_window)
    products_frame.pack(expand=True, fill=tk.BOTH, padx=10, pady=10)

    

    def display_products(products):
        for widget in products_frame.winfo_children():
            widget.destroy()

        columns = 4
        row_index = 0
        column_index = 0

        for product in products:
            product_id, product_name = product
    
            cursor.execute("SELECT photo FROM product WHERE id = %s", (product_id,))
            photo_data = cursor.fetchone()[0]
            if photo_data:
                photo = Image.open(io.BytesIO(photo_data))
                photo = photo.resize((100, 100), Image.LANCZOS)
                photo = ImageTk.PhotoImage(photo)
                photo_label = tk.Label(products_frame, image=photo)
                photo_label.image = photo
                photo_label.grid(row=row_index, column=column_index, padx=5, pady=5, sticky="nsew")

            product_label = tk.Label(products_frame, text=product_name, bg='lightblue', relief=tk.RAISED, font=('Arial', 14))
            product_label.bind("<Button-1>", lambda event, id=product_id: show_product_info(id))
            product_label.grid(row=row_index + 1, column=column_index, padx=5, pady=5, sticky="nsew")
            
            add_to_cart_button = tk.Button(products_frame, text="Добавить в корзину", command=lambda id=product_id: add_to_cart(id))
            add_to_cart_button.grid(row=row_index + 2, column=column_index, padx=5, pady=5)

            column_index += 1
            if column_index >= columns:
                column_index = 0
                row_index += 2
    
    sql = "SELECT name, surname, address, number, photo FROM user WHERE id = %s"
    cursor.execute(sql, (logged_in_user[0],))
    user_info = cursor.fetchone()

    if user_info:
        user_name, user_surname, user_address, user_number, user_photo_data = user_info
    else:
        user_name, user_surname, user_address, user_number, user_photo_data = "", "", "", "", None

    user_info_frame = tk.Frame(delivery_window, bg='#FFFFFF', bd=2, relief=tk.RIDGE)
    user_info_frame.place(relx=0.99, rely=0.01, anchor=tk.NE)

    user_name_label = tk.Label(user_info_frame, text=f"{logged_in_user[1]} {logged_in_user[2]}", font=('Arial', 12), bg='#FFFFFF')
    user_name_label.pack(side=tk.LEFT, padx=5)
    
    user_name_label.bind("<Button-1>", lambda event: show_user_info(logged_in_user, delivery_window))

    def show_user_info(logged_in_user, delivery_window):
        user_info_window = tk.Toplevel(delivery_window)
        user_info_window.title("Информация о пользователе")
    
        tab_control = ttk.Notebook(user_info_window)

        info_tab = ttk.Frame(tab_control)
        change_password_tab = ttk.Frame(tab_control)

        tab_control.add(info_tab, text='Информация')
        tab_control.add(change_password_tab, text='Смена пароля')
        tab_control.pack(expand=True, fill='both')

        info_frame = tk.Frame(info_tab, bg='#FFFFFF')
        info_frame.pack(expand=True, fill='both')

        label_name = tk.Label(info_frame, text=f"Имя: {logged_in_user[1]}", font=('Arial', 14), bg='#FFFFFF')
        label_name.grid(row=0, column=0, padx=10, pady=5, sticky='w')
    
        label_surname = tk.Label(info_frame, text=f"Фамилия: {logged_in_user[2]}", font=('Arial', 14), bg='#FFFFFF')
        label_surname.grid(row=1, column=0, padx=10, pady=5, sticky='w')
    
        label_address = tk.Label(info_frame, text=f"Адрес: {logged_in_user[5]}", font=('Arial', 14), bg='#FFFFFF')
        label_address.grid(row=2, column=0, padx=10, pady=5, sticky='w')
    
        label_number = tk.Label(info_frame, text=f"Номер: {logged_in_user[6]}", font=('Arial', 14), bg='#FFFFFF')
        label_number.grid(row=3, column=0, padx=10, pady=5, sticky='w')

        def update_user_field(field, new_value, label_status):
            if not new_value:
                label_status.config(text=f"{field.capitalize()} не может быть пустым")
                return

            sql = f"UPDATE user SET {field} = %s WHERE id = %s"
            cursor.execute(sql, (new_value, logged_in_user[0]))
            db.commit()
            label_status.config(text=f"{field.capitalize()} обновлено")
            setattr(logged_in_user, field, new_value)

        entry_new_name = tk.Entry(info_frame, font=('Arial', 12), bd=2, relief=tk.SOLID)
        entry_new_name.grid(row=0, column=1, padx=10, pady=5)
        button_update_name = tk.Button(info_frame, text="Обновить имя", font=('Arial', 12), 
                                   command=lambda: update_user_field('name', entry_new_name.get(), label_status_name))
        button_update_name.grid(row=0, column=2, padx=10, pady=5)
        label_status_name = tk.Label(info_frame, text="", font=('Arial', 12), bg='#FFFFFF')
        label_status_name.grid(row=0, column=3, padx=10, pady=5)

        entry_new_surname = tk.Entry(info_frame, font=('Arial', 12), bd=2, relief=tk.SOLID)
        entry_new_surname.grid(row=1, column=1, padx=10, pady=5)
        button_update_surname = tk.Button(info_frame, text="Обновить фамилию", font=('Arial', 12), 
                                      command=lambda: update_user_field('surname', entry_new_surname.get(), label_status_surname))
        button_update_surname.grid(row=1, column=2, padx=10, pady=5)
        label_status_surname = tk.Label(info_frame, text="", font=('Arial', 12), bg='#FFFFFF')
        label_status_surname.grid(row=1, column=3, padx=10, pady=5)

        entry_new_address = tk.Entry(info_frame, font=('Arial', 12), bd=2, relief=tk.SOLID)
        entry_new_address.grid(row=2, column=1, padx=10, pady=5)
        button_update_address = tk.Button(info_frame, text="Обновить адрес", font=('Arial', 12), 
                                      command=lambda: update_user_field('address', entry_new_address.get(), label_status_address))
        button_update_address.grid(row=2, column=2, padx=10, pady=5)
        label_status_address = tk.Label(info_frame, text="", font=('Arial', 12), bg='#FFFFFF')
        label_status_address.grid(row=2, column=3, padx=10, pady=5)

        entry_new_number = tk.Entry(info_frame, font=('Arial', 12), bd=2, relief=tk.SOLID)
        entry_new_number.grid(row=3, column=1, padx=10, pady=5)
        button_update_number = tk.Button(info_frame, text="Обновить номер", font=('Arial', 12), 
                                     command=lambda: update_user_field('number', entry_new_number.get(), label_status_number))
        button_update_number.grid(row=3, column=2, padx=10, pady=5)
        label_status_number = tk.Label(info_frame, text="", font=('Arial', 12), bg='#FFFFFF')
        label_status_number.grid(row=3, column=3, padx=10, pady=5)

        change_password_frame = tk.Frame(change_password_tab, bg='#FFFFFF')
        change_password_frame.pack(expand=True, fill='both')

        label_old_password = tk.Label(change_password_frame, text="Старый пароль:", font=('Arial', 14), bg='#FFFFFF')
        label_old_password.grid(row=0, column=0, padx=10, pady=5, sticky='e')
        entry_old_password = tk.Entry(change_password_frame, show="*", font=('Arial', 12), bd=2, relief=tk.SOLID)
        entry_old_password.grid(row=0, column=1, padx=10, pady=5)

        label_new_password = tk.Label(change_password_frame, text="Новый пароль:", font=('Arial', 14), bg='#FFFFFF')
        label_new_password.grid(row=1, column=0, padx=10, pady=5, sticky='e')
        entry_new_password = tk.Entry(change_password_frame, show="*", font=('Arial', 12), bd=2, relief=tk.SOLID)
        entry_new_password.grid(row=1, column=1, padx=10, pady=5)

        label_new_password_confirm = tk.Label(change_password_frame, text="Повторите новый пароль:", font=('Arial', 14), bg='#FFFFFF')
        label_new_password_confirm.grid(row=2, column=0, padx=10, pady=5, sticky='e')
        entry_new_password_confirm = tk.Entry(change_password_frame, show="*", font=('Arial', 12), bd=2, relief=tk.SOLID)
        entry_new_password_confirm.grid(row=2, column=1, padx=10, pady=5)

        def change_password():
            old_password = entry_old_password.get()
            new_password = entry_new_password.get()
            new_password_confirm = entry_new_password_confirm.get()

            if not all([old_password, new_password, new_password_confirm]):
                label_status_password.config(text="Все поля должны быть заполнены")
                return

            if new_password != new_password_confirm:
                label_status_password.config(text="Новые пароли не совпадают")
                return

            if logged_in_user[4]:
                if not sha256_crypt.verify(old_password, logged_in_user[4]):
                    label_status_password.config(text="Старый пароль неверный")
                    return
            else:
                label_status_password.config(text="Старый пароль не был установлен")
                return

            new_hashed_password = sha256_crypt.hash(new_password)
            sql = "UPDATE user SET password_hash = %s WHERE id = %s"
            cursor.execute(sql, (new_hashed_password, logged_in_user[0]))
            db.commit()
            label_status_password.config(text="Пароль успешно изменен")
    
            logged_in_user[4] = new_hashed_password

        button_change_password = tk.Button(change_password_frame, text="Изменить пароль", font=('Arial', 12), command=change_password)
        button_change_password.grid(row=3, columnspan=2, pady=10)

        label_status_password = tk.Label(change_password_frame, text="", font=('Arial', 12), bg='#FFFFFF')
        label_status_password.grid(row=4, columnspan=2, pady=10)

    def show_product_info(product_id):
        sql = """SELECT product.name, product.description, product.price, product.weight, restaurant.name, category.category
                 FROM product
                 JOIN restaurant ON product.restaurant_id = restaurant.id
                 JOIN category_has_product ON product.id = category_has_product.product_id
                 JOIN category ON category_has_product.category_id = category.id
                 WHERE product.id = %s"""
        cursor.execute(sql, (product_id,))
        product = cursor.fetchone()

        if product:
            product_window = tk.Toplevel(delivery_window)
            product_window.title(product[0]) 


            product_info = f"""
            Описание: {product[1]}
            Цена: {product[2]}
            Вес: {product[3]}. гр.
            Ресторан: {product[4]}
            Категория: {product[5]}
            """
            product_info_label = tk.Label(product_window, text=product_info, font=('Arial', 14), padx=20, pady=20)
            product_info_label.pack()
        else:
            error_window = tk.Toplevel(delivery_window)
            error_window.title("Ошибка")
            error_label = tk.Label(error_window, text=f"Продукт с ID {product_id} не найден", font=('Arial', 14), padx=20, pady=20)
            error_label.pack()
    
    button_open_cart = tk.Button(search_frame, text="Корзина", font=('Arial', 12), command=lambda: open_cart_window(logged_in_user))
    button_open_cart.pack(side=tk.TOP, pady=10, padx=10)

    def open_cart_window(logged_in_user):
        cart_window = tk.Toplevel(root)
        cart_window.title("Корзина")

        cart_frame = tk.Frame(cart_window)
        cart_frame.pack(expand=True, fill='both', padx=10, pady=10)

        def display_cart():
            for widget in cart_frame.winfo_children():
                widget.destroy()

            cursor.execute("""SELECT cart.id, product.id, product.name, product.price
                            FROM cart
                            JOIN product ON cart.product_id = product.id
                            WHERE cart.user_id = %s""", (logged_in_user[0],))
            cart_items = cursor.fetchall()

            if cart_items:
                total_price = 0

                for index, cart_item in enumerate(cart_items):
                    cart_id, product_id, product_name, product_price = cart_item
                    label_product = tk.Label(cart_frame, text=f"{product_name} - {product_price} руб.", font=('Arial', 12), bg='lightblue', relief=tk.RAISED)
                    label_product.grid(row=index, column=0, padx=5, pady=5, sticky="nsew")

                    delete_button = tk.Button(cart_frame, text="Удалить", command=lambda id=cart_id: delete_from_cart(id))
                    delete_button.grid(row=index, column=1, padx=5, pady=5)

                    total_price += product_price

                label_total_price = tk.Label(cart_frame, text=f"Общая сумма: {total_price} руб.", font=('Arial', 12), bg='lightblue', relief=tk.RAISED)
                label_total_price.grid(row=len(cart_items), column=0, columnspan=2, padx=5, pady=5, sticky="nsew")

                order_button = tk.Button(cart_frame, text="Заказать", command=place_order)
                order_button.grid(row=len(cart_items) + 1, column=0, columnspan=2, padx=5, pady=5)

            else:
                label_empty_cart = tk.Label(cart_frame, text="Корзина пуста", font=('Arial', 14), padx=20, pady=20)
                label_empty_cart.grid(row=0, column=0, columnspan=2)

        def place_order():
            cursor.execute("SELECT address FROM user WHERE id = %s", (logged_in_user[0],))
            user_address = cursor.fetchone()[0]

            total_price = 0
            cursor.execute("""SELECT product.price
                        FROM cart
                        JOIN product ON cart.product_id = product.id
                        WHERE cart.user_id = %s""", (logged_in_user[0],))
            product_prices = cursor.fetchall()
            for price in product_prices:
                total_price += price[0]

            payment_window = tk.Toplevel(root)
            payment_window.title("Выберите способ оплаты")

            payment_options = ["Online", "Cash"]
            selected_payment = tk.StringVar(payment_window)
            selected_payment.set(payment_options[0])

            for i, option in enumerate(payment_options):
                tk.Radiobutton(payment_window, text=option, variable=selected_payment, value=option).grid(row=i, column=0, padx=10, pady=5, sticky="w")

            cursor.execute("""INSERT INTO orders (price, status, address, payment, order_time, user_id)
                            VALUES (%s, %s, %s, %s, NOW(), %s)""",
                            (total_price, "accepted", user_address, selected_payment.get(), logged_in_user[0]))

            db.commit()  



            cursor.execute("DELETE FROM cart WHERE user_id = %s", (logged_in_user[0],))
            db.commit()

            display_cart()

        display_cart()

    
    def delete_from_cart(cart_id):
        sql = "DELETE FROM cart WHERE id = %s"
        cursor.execute(sql, (cart_id,))
        db.commit()
        
# Функция добавления товара в корзину
    def add_to_cart(product_id):
        sql = "INSERT INTO cart (user_id, product_id, quantity) VALUES (%s, %s, %s)"
        values = (logged_in_user[0], product_id, 1)
        cursor.execute(sql, values)
        db.commit()
        label_status.config(text="Товар добавлен в корзину")


    cursor.execute("SELECT id, name FROM product")
    display_products(cursor.fetchall())

# окно входа 
root = tk.Tk()
root.title("Сервис для доставки еды")

screen_width = root.winfo_screenwidth()

screen_height = root.winfo_screenheight()
root.geometry(f"{screen_width}x{screen_height}")

image_path = "C:/Users/Professional/PycharmProjects/MouthProject/night-3078326_1280-min.jpg"
image = Image.open(image_path)

image = image.resize((screen_width, screen_height), Image.LANCZOS)
bg_image = ImageTk.PhotoImage(image)

label_bg = tk.Label(root, image=bg_image)
label_bg.place(x=0, y=0, relwidth=1, relheight=1)

login_frame_width = 300
login_frame_height = 280

login_frame = tk.Frame(root, bg='#FFFFFF', bd=2, relief=tk.RIDGE)
login_frame.place(relx=0.5, rely=0.4, anchor=tk.CENTER, width=login_frame_width, height=login_frame_height)

label_username = tk.Label(login_frame, text="Имя:", bg='#FFFFFF', font=('Arial', 14))
label_username.pack(pady=10)
entry_username = tk.Entry(login_frame, font=('Arial', 12), bd=2, relief=tk.SOLID)
entry_username.pack(pady=10)

label_password = tk.Label(login_frame, text="Пароль:", bg='#FFFFFF', font=('Arial', 14))
label_password.pack(pady=10)
entry_password = tk.Entry(login_frame, show="*", font=('Arial', 12), bd=2, relief=tk.SOLID)
entry_password.pack(pady=10)

label_status = tk.Label(login_frame, text="", bg='#FFFFFF', font=('Arial', 12))
label_status.pack(pady=10)

show_password = tk.BooleanVar()
show_password_checkbox = tk.Checkbutton(login_frame, text="Показать пароль", variable=show_password, command=toggle_password_visibility, bg='#FFFFFF')
show_password_checkbox.pack(side=tk.RIGHT, pady=10)

button_login = tk.Button(login_frame, text="Войти", font=('Arial', 12), command=login_user)
button_login.pack(side=tk.RIGHT,pady=10)

button_register_main = tk.Button(login_frame, text="Регестрация", font=('Arial', 12), command=open_registration_window)
button_register_main.pack(side=tk.TOP, pady=10)


root.bg_image = bg_image

root.mainloop()
db.close()
