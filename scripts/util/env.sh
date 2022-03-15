#/bin/bash 
NOCOLOR='\033[0;0m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'

ENV_FILE='.env'
	if test -f "$ENV_FILE"; 
	then
		echo -e "${YELLOW}Existing Env File Detected. Skipping."${NOCOLOR}
	else
		echo -e "${CYAN} Setting Defaults ${NOCOLOR}"
		touch "$ENV_FILE"
		echo "PROJECT_NAME=file-processor" >> $ENV_FILE
		echo "SERVER_HOST=file-processor-server" >> $ENV_FILE
		echo "SERVER_HTTP_PORT=80" >> $ENV_FILE
		echo "SERVER_HTTPS_PORT=443" >> $ENV_FILE
		echo "CACHE_PASS=$(openssl rand -base64 20)" >> $ENV_FILE
		echo "API_COOKIE_SECRET=$(openssl rand -base64 20)" >> $ENV_FILE
		echo "CACHE_PORT=6379" >> $ENV_FILE
		echo "CACHE_HOST=file-processor-cache" >> $ENV_FILE
		echo "HTTPS=off" >> $ENV_FILE
		echo "MODSEC=off" >> $ENV_FILE
		echo "API_PORT=8085" >> $ENV_FILE
		echo "API_HOST=file-processor-api" >> $ENV_FILE
		echo "APP_PORT=8080" >> $ENV_FILE
		echo "APP_HOST=file-processor-app" >> $ENV_FILE
		echo "DOMAIN=localhost" >> $ENV_FILE
	fi