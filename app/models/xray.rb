class Xray < ActiveRecord::Base
  
  belongs_to :diagnosis

  # Paperclip
  has_attached_file :photo,
    :styles => {
      :thumb=> "100x100#",
      :small  => "150x150>" },
    :storage => ENV['S3_BUCKET'] ? :s3 : :filesystem,
    :s3_credentials => {
      :access_key_id => ENV['S3_KEY'],
      :secret_access_key => ENV['S3_SECRET']
    },
    :bucket => ENV['S3_BUCKET'],
    :path => ENV['S3_BUCKET'] ? "xrays/:attachment/:id/:style/:basename.:extension" : ":rails_root/public/system/xrays/:attachment/:id/:style/:basename.:extension",
    :url => ENV['S3_BUCKET'] ? "xrays/:attachment/:id/:style/:basename.:extension" : "/system/xrays/:attachment/:id/:style/:basename.:extension"

    validates_attachment_presence :photo
  
end
