# Встановлюємо базовий образ Python для потрібної архітектури
FROM --platform=linux/amd64 python:3.9-slim

# Встановлюємо робочу директорію
WORKDIR /app

# Копіюємо файл hello.py до робочої директорії
COPY hello.py .

# Відкриваємо порт 8080
EXPOSE 80

# Запускаємо веб-сервер
CMD ["python", "hello.py"]
