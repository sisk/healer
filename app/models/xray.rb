class Xray < ActiveRecord::Base

  PHOTO_DIR = (Rails.env == "development") ? "_development/xrays/:attachment/:id/:style.:extension" : "xrays/:attachment/:id/:style.:extension"

  belongs_to :operation
  belongs_to :patient_case

  scope :pre_op, where('xrays.operation_id is ?', nil)
  scope :post_op, where('xrays.operation_id is not ?', nil)

  validates_presence_of :patient_case

  # Paperclip
  has_attached_file :photo,
    :styles => {
      :original => "50000x50000>",
      :tiny=> "60x60#",
      :thumb=> "100x100#",
      :small  => "200x200>" },
    :storage => ENV['S3_BUCKET'].present? ? :s3 : :filesystem,
    :s3_credentials => {
      :access_key_id => ENV['S3_KEY'],
      :secret_access_key => ENV['S3_SECRET']
    },
    :bucket => ENV['S3_BUCKET'],
    :path => ENV['S3_BUCKET'].present? ? PHOTO_DIR : ":rails_root/public/system/#{PHOTO_DIR}",
    :url => ENV['S3_BUCKET'].present? ? PHOTO_DIR : "/system/#{PHOTO_DIR}",
    :auto_orient => true

  validates_attachment_presence :photo

  def to_s
    str = "X-ray: #{patient_case.to_s}"
    str += " - " + date_time.to_s if date_time.present?
    return str
  end

end
