class SmokeMailer < ApplicationMailer
  def ping
    mail(
      to: "contato@adoteumfilhopovo.org.br",
      subject: "[smoke] adoteumfilhopovo"
    ) do |format|
      format.text { render plain: "Smoke test: infraestrutura de email funcionando." }
    end
  end
end
