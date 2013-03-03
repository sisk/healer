module Healer
  S3_BUCKET = (Rails.env == "production") ? "healer-app-production" : "healer-app-development"
end