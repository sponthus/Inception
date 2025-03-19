#!/bin/bash

echo "---- Configuration of your environment ----"
echo "-------------------------------------------"
echo "Emails will automatically be user@42lyon.fr"
echo "-- Passwords are automatically generated --"

SCRIPT_DIR="$(cd "$(dirname "$0")" &>/dev/null && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." &>/dev/null && pwd)"
ENV_FILE="$PROJECT_ROOT/srcs/.env"
SECRETS_DIR="$PROJECT_ROOT/secrets"

mkdir -p "$SECRETS_DIR"

generate_password() {
    local password_file="$1"
    local password=$(openssl rand -hex 8)
    echo "$password" > "$SECRETS_DIR/$password_file"
    echo "$password"
}

validate_admin_name() {
    local admin_name="$1"
	if ! echo "$admin_name" | grep -qE '^[a-z]+$'; then
        echo "This field can only contain a-z and digits." >&2
        return 1
    fi
    if echo "$admin_name" | grep -iE "admin|administrator|adm*" > /dev/null; then
		echo "Admin name can't contain 'admin' or its variations." >&2
        return 1
    fi
    return 0
}

validate_name() {
    local name="$1"
    if [ -z "$name" ]; then
		echo "This field can't be empty." >&2
        return 1
	fi
	if ! echo "$name" | grep -qE '^[a-z]+$'; then
        echo "This field can only contain a-z and digits." >&2
        return 1
    fi
    return 0
}

is_empty() {
	local name="$1"
    if [ -z "$name" ]; then
		echo "This field can't be empty." >&2
        return 1
	fi
}

get_validated_input() {
    local prompt="$1"
    local validation_func="$2"
    local input

    while true; do
        read -p "$prompt" input
        if [ -z "$validation_func" ]; then
            echo "$input"
            return 0
        else
            if $validation_func "$input"; then
                echo "$input"
                return 0
            fi
        fi
    done
}

DB_PW=$(generate_password "db_password.txt")
DB_ROOT_PW=$(generate_password "db_root_password.txt")
WORDPRESS_ADMIN_PW=$(generate_password "wp_admin_password.txt")
WORDPRESS_USER_PW=$(generate_password "wp_user_password.txt")


WORDPRESS_USER=$(get_validated_input "Enter your login: " validate_name)
WORDPRESS_ADMIN=$(get_validated_input "Enter wordpress admin name: " validate_admin_name)
WORDPRESS_TITLE=$(get_validated_input "Enter page name: " is_empty)

cat > "$ENV_FILE" << EOF
DOMAIN_NAME=$WORDPRESS_USER.42.fr

DB_NAME=wordpress
DB_USER=maria
DB_PW=$DB_PW
DB_ROOT_PW=$DB_ROOT_PW

WORDPRESS_TITLE="$WORDPRESS_TITLE"

WORDPRESS_ADMIN=$WORDPRESS_ADMIN
WORDPRESS_ADMIN_PW=$WORDPRESS_ADMIN_PW
WORDPRESS_ADMIN_MAIL=$WORDPRESS_ADMIN@42lyon.fr

WORDPRESS_USER=$WORDPRESS_USER
WORDPRESS_USER_MAIL=$WORDPRESS_USER@42lyon.fr
WORDPRESS_USER_PW=$WORDPRESS_USER_PW
EOF

echo " -> Done !"
echo ".env has been created in : $ENV_FILE"
echo "Passwords have been saved in : $SECRETS_DIR"