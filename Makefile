DOMAIN   = guinee.career.selys.app
EMAIL    = hi@selys-africa.com
NGINX_AVAILABLE = /etc/nginx/sites-available/$(DOMAIN)
NGINX_ENABLED   = /etc/nginx/sites-enabled/$(DOMAIN)

.PHONY: deploy ssl reload update logs down

## Premier déploiement complet (build + SSL + nginx)
deploy:
	docker compose up -d --build
	sudo cp nginx/$(DOMAIN).conf $(NGINX_AVAILABLE)
	sudo ln -sf $(NGINX_AVAILABLE) $(NGINX_ENABLED)
	sudo certbot --nginx -d $(DOMAIN) --email $(EMAIL) --agree-tos --no-eff-email
	sudo nginx -t && sudo systemctl reload nginx

## Obtenir / renouveler le certificat SSL uniquement
ssl:
	sudo certbot --nginx -d $(DOMAIN) --email $(EMAIL) --agree-tos --no-eff-email
	sudo nginx -t && sudo systemctl reload nginx

## Recharger nginx (après modif de config)
reload:
	sudo nginx -t && sudo systemctl reload nginx

## Mettre à jour l'application (nouveau build sans toucher nginx)
update:
	docker compose build app
	docker compose up -d app

## Voir les logs de l'app
logs:
	docker compose logs -f app

## Arrêter l'application
down:
	docker compose down
