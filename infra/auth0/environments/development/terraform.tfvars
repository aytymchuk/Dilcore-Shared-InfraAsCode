env_name                    = "development"
web_app_callbacks           = ["$(PLATFORM_WEB_APP_BASE_URL)/callback", "https://localhost:7200/callback", "http://localhost:5200/callback"]
web_app_allowed_logout_urls = ["$(PLATFORM_WEB_APP_BASE_URL)"]
web_app_web_origins         = ["$(PLATFORM_WEB_APP_BASE_URL)", "https://localhost:7200", "http://localhost:5200"]

api_doc_callbacks           = ["$(PLATFORM_API_BASE_URL)/api-doc/", "https://localhost:7191/api-doc/", "https://dev.api.dilcore.com/api-doc/", "http://127.0.0.1:8000/scalar/", "http://localhost:8000/scalar/", "$(PLATFORM_AI_CORE_BASE_URL)/scalar/"]
api_doc_allowed_logout_urls = ["$(PLATFORM_API_BASE_URL)/api-doc/", "https://localhost:7191/api-doc/", "https://dev.api.dilcore.com/api-doc/", "http://127.0.0.1:8000/scalar/", "http://localhost:8000/scalar/", "$(PLATFORM_AI_CORE_BASE_URL)/scalar/"]
api_doc_web_origins         = ["$(PLATFORM_API_BASE_URL)/api-doc/", "https://localhost:7191/api-doc/", "https://dev.api.dilcore.com/api-doc/", "http://127.0.0.1:8000/scalar/", "http://localhost:8000/scalar/", "$(PLATFORM_AI_CORE_BASE_URL)/scalar/"]
