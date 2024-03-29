class WelcomeMailer < ApplicationMailer
  default from: 'adriany.webdev@gmail.com'

  def welcome_email
    @user = params[:user]
    @url = 'http://127.0.0.1:3000/users/sign_in'
    attachments.inline['nexellia.png'] = File.read('app/assets/images/nexellia.png')
    mail(to: @user.email, subject: 'Welcome to Nexellia!')
  end
end
