class Mailer < ActionMailer::Base
  default :from => "healer.app@gmail.com"
  
  def test(to)
    mail(:to => to.email, :subject => "test")
  end
end
