require "./server"

Lucky::Session::Store.configure do
  settings.key = "pet_store"
  settings.secret = Lucky::Server.settings.secret_key_base
end
