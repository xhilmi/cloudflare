#!/bin/bash

# Cloudflare API credentials
EMAIL="YOUR_EMAIL"
KEY="YOUR_API_KEY"
ZONE_ID="YOUR_ZONE_ID"
AUTH_TOKEN="YOUR_AUTH_TOKEN"

# Function to list DNS records
function list_dns() {
  echo -e "ID                             \tTYPE\tDOMAIN                   \tVALUE" && \
  curl -s --request GET \
    --url https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records \
    --header 'Content-Type: application/json' \
    --header "X-Auth-Email: $EMAIL" \
    --header "X-Auth-Key: $AUTH_KEY" \
    --header "Authorization: Bearer $AUTH_TOKEN" \
    | jq -r '.result[] | [.id, .type, .name, .content] | @tsv' \
    | column -t -s $'\t'
}

# Function to delete a DNS record
function delete_dns() {
  read -p "Enter the ID of the DNS record to delete: " id
  curl --request DELETE \
    --url "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$id" \
    --header "Content-Type: application/json" \
    --header "X-Auth-Email: $EMAIL" \
    --header "X-Auth-Key: $KEY" \
    --header "Authorization: Bearer 3NnnUXD_TOTnjYsFerGm0ds6MZe1H7qeg845Ur-o" \
    | jq
}

# Function to add a DNS record
function add_dns() {
  read -p "Enter your IP address: " ipaddress
  read -p "Enter your domain name: " domainname
  curl --request POST \
    --url "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records" \
    --header "Content-Type: application/json" \
    --header "X-Auth-Email: $EMAIL" \
    --header "X-Auth-Key: $KEY" \
    --header "Authorization: Bearer 3NnnUXD_TOTnjYsFerGm0ds6MZe1H7qeg845Ur-o" \
    --data '{
      "content": "'"$ipaddress"'",
      "name": "'"$domainname"'",
      "proxied": false,
      "type": "A",
      "comment": "Added From Cloudflare API",
      "ttl": 1
    }' | jq
}

# Main menu
while true; do
  echo ""
  echo "Cloudflare DNS Management"
  echo "-------------------------"
  echo "1. List DNS Records"
  echo "2. Delete a DNS Record"
  echo "3. Add a DNS Record"
  echo "4. Exit"
  read -p "Enter your choice: " choice

  case $choice in
    1)
      list_dns
      ;;
    2)
      delete_dns
      ;;
    3)
      add_dns
      ;;
    4)
      echo "Exiting..."
      exit 0
      ;;
    *)
      echo "Invalid choice"
      ;;
  esac
done
