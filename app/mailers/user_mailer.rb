class UserMailer < ApplicationMailer

  default :from => 'Rails | projetobase <rails@projetobase.com.br>'

  def signup_email(usuario, password)
    @usuario = usuario
    @password = password
    mail(
      :to => @usuario.email,
      :subject => 'Cadastro no sistema'
    )
  end

end