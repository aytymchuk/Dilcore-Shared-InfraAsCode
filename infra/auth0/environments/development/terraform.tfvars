env_name                    = "development"
web_app_callbacks           = ["http://localhost:3000/api/auth/callback"]
web_app_allowed_logout_urls = ["http://localhost:3000"]
web_app_web_origins         = ["http://localhost:3000"]

api_doc_callbacks           = ["$(PLATFORM_API_BASE_URL)/api-doc/", "https://localhost:7191/api-doc/"]
api_doc_allowed_logout_urls = ["$(PLATFORM_API_BASE_URL)/api-doc/", "https://localhost:7191/api-doc/"]
api_doc_web_origins         = ["$(PLATFORM_API_BASE_URL)/api-doc/", "https://localhost:7191/api-doc/"]
