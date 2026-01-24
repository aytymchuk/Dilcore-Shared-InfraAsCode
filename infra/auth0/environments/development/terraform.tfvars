env_name                    = "development"
web_app_callbacks           = ["$(PLATFORM_CONTAINER_WEB-APP_NAME)/callback", "https://localhost:7200/callback", "http://localhost:5200/callback"]
web_app_allowed_logout_urls = ["$(PLATFORM_CONTAINER_WEB-APP_NAME)"]
web_app_web_origins         = ["$(PLATFORM_CONTAINER_WEB-APP_NAME)", "https://localhost:7200", "http://localhost:5200"]

api_doc_callbacks           = ["$(PLATFORM_API_BASE_URL)/api-doc/", "https://localhost:7191/api-doc/", "https://dev.api.dilcore.com/api-doc/"]
api_doc_allowed_logout_urls = ["$(PLATFORM_API_BASE_URL)/api-doc/", "https://localhost:7191/api-doc/", "https://dev.api.dilcore.com/api-doc/"]
api_doc_web_origins         = ["$(PLATFORM_API_BASE_URL)/api-doc/", "https://localhost:7191/api-doc/", "https://dev.api.dilcore.com/api-doc/"]
