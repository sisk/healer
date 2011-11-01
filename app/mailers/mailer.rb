class Mailer < ActionMailer::Base
  include ActionDispatch::Routing::UrlFor
  # include ActionController::PolymorphicRoutes
  include Rails.application.routes.url_helpers

  default_url_options[:host] = 'healer.ws'
  default :from => "healer.app@gmail.com"

  def case_added(patient_case, recipients = [])
    @patient_case = patient_case
    mail(:to => recipients)
  end

end
