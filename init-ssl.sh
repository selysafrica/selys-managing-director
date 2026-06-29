#!/bin/bash
set -e

DOMAIN="guinee.career.selys.app"
EMAIL="hi@selys-africa.com"

echo "==> Étape 1 : démarrage en HTTP uniquement (sans bloc SSL)..."
# Désactiver le bloc HTTPS le temps d'obtenir le certificat
mv nginx/conf.d/default.conf nginx/conf.d/default.conf.bak
cp nginx/conf.d/default.http.conf nginx/conf.d/default.conf

docker compose up -d app nginx

echo "==> Étape 2 : obtention du certificat Let's Encrypt..."
docker compose run --rm certbot certonly \
  --webroot \
  --webroot-path=/var/www/certbot \
  --email "$EMAIL" \
  --agree-tos \
  --no-eff-email \
  -d "$DOMAIN"

echo "==> Étape 3 : restauration de la config HTTPS..."
cp nginx/conf.d/default.conf.bak nginx/conf.d/default.conf

echo "==> Étape 4 : redémarrage nginx avec SSL + démarrage certbot auto-renouvellement..."
docker compose up -d

echo ""
echo "Déployé sur https://$DOMAIN"
