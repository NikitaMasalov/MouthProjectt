import mysql.connector
import tkinter as tk
from PIL import Image, ImageTk
from passlib.hash import sha256_crypt

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
        if sha256_crypt.verify(password, user[3]):  
            label_status.config(text="Вход выполнен успешно")
            open_delivery_viewing_window() 
        else:
            label_status.config(text="Неверный пароль")
    else:
        label_status.config(text="Пользователь не найден")

#Основное окно покупок
def open_delivery_viewing_window():
    open_delivery_viewing_window = tk.Toplevel(root)
    open_delivery_viewing_window.title("Сервис для доставки еды")

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
