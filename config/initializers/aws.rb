config_vals = YAML.load_file("config/aws.yml")[Rails.env] || {}
AWS.config(
  access_key_id: "#{config_vals["AWS_ACCESS_KEY_ID"]}",
  secret_access_key: "#{config_vals["AWS_SECRET_ACCESS_KEY"]}",
  region: "#{config_vals["AWS_REGION"]}"
)