OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '660552000654821', '9af93ddb33c00a5a572d8ea6caf52473'
end