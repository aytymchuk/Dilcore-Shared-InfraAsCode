env_name                    = "qa"
web_app_callbacks           = ["$(PLATFORM_CONTAINER_WEB-APP_NAME)/callback"]
web_app_allowed_logout_urls = ["$(PLATFORM_CONTAINER_WEB-APP_NAME)"]
web_app_web_origins         = ["$(PLATFORM_CONTAINER_WEB-APP_NAME)"]

api_doc_callbacks           = ["$(PLATFORM_API_BASE_URL)/api-doc/"]
api_doc_allowed_logout_urls = ["$(PLATFORM_API_BASE_URL)/api-doc/"]
api_doc_web_origins         = ["$(PLATFORM_API_BASE_URL)/api-doc/"]
