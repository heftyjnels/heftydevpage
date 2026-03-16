class LeadMailer < ApplicationMailer
  def new_lead(lead)
    @lead = lead
    mail(
      to: Jumpstart.config.support_email,
      subject: "New lead from #{@lead.name} – #{@lead.company.presence || "No company"}"
    )
  end

  def auto_reply(lead)
    @lead = lead
    mail(
      to: @lead.email,
      subject: "Thanks for contacting Heftydev"
    )
  end
end
