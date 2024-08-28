#!/bin/bash
set -x
# Нова строка для додавання або видалення
ACTION=$1
ITEM=$2

# Шлях до Terraform файлу
TF_FILE="varfiable.tf"

add_new_item() {
  # Перевірка чи вже є новий елемент у списку
  if ! grep -q "$ITEM" "$TF_FILE"; then
    # Додавання нового рядка до списку
    awk -v new_item="$ITEM" '
    /default = \[.*\]/ {
      # Зберігаємо оригінальний рядок
      original_line = $0;
      # Додаємо новий елемент до списку
      gsub(/\]$/, ", \"" new_item "\"]", original_line);
      print original_line;
      next;
    }
    { print }
    ' "$TF_FILE" > tmpfile && mv tmpfile "$TF_FILE"
  else
    echo "$ITEM вже існує в списку."
  fi
}



# Виконання дії на основі аргументу
if [ "$ACTION" == "add" ]; then
  add_new_item
else
  echo "Неправильна команда. Використовуйте 'add' або 'remove'."
fi
