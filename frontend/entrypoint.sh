#!/bin/sh

# Replace placeholder with the actual value
for file in /usr/share/nginx/html/assets/index*.js; do
    echo "Editing file: $file"
    sed -i "s/___vabu___/$VITE_API_BASE_URL/g" "$file"
done
echo "script working"

# Start nginx
nginx -g 'daemon off;'
