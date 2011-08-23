class Mailer < ActionMailer::Base
  include ActionController::UrlWriter
  
  default :from => "healer.app@gmail.com"
  
  def case_added(patient_case, recipients = [])
    @patient_case = patient_case
    mail(:to => recipients)
  end

end
