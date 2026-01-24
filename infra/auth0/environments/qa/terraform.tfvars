env_name                    = "qa"
web_app_callbacks           = ["$(PLATFORM_WEB_APP_BASE_URL)/callback"]
web_app_allowed_logout_urls = ["$(PLATFORM_WEB_APP_BASE_URL)"]
web_app_web_origins         = ["$(PLATFORM_WEB_APP_BASE_URL)"]

api_doc_callbacks           = ["$(PLATFORM_API_BASE_URL)/api-doc/"]
api_doc_allowed_logout_urls = ["$(PLATFORM_API_BASE_URL)/api-doc/"]
api_doc_web_origins         = ["$(PLATFORM_API_BASE_URL)/api-doc/"]
