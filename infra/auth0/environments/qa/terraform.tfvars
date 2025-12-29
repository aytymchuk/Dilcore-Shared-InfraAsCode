env_name                    = "qa"
web_app_callbacks           = ["https://app.qa.dilcore.com/api/auth/callback"]
web_app_allowed_logout_urls = ["https://app.qa.dilcore.com"]
web_app_web_origins         = ["https://app.qa.dilcore.com"]

api_doc_callbacks           = ["$(PLATFORM_API_BASE_URL)/api-doc/"]
api_doc_allowed_logout_urls = ["$(PLATFORM_API_BASE_URL)/api-doc/"]
api_doc_web_origins         = ["$(PLATFORM_API_BASE_URL)/api-doc/"]
