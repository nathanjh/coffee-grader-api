class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@coffee-grader.com'
  layout 'mailer'
end
