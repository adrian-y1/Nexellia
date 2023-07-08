class PasswordMailer < Devise::Mailer
  helper :application 
  include Devise::Controllers::UrlHelpers
  default template_path: 'devise/mailer'

  def reset_password_instructions(record, token, opts={})
    attachments.inline['nexellia.png'] = File.read('app/assets/images/nexellia.png')
    super
  end
end