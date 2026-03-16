class ContactsController < ApplicationController
  layout "marketing"

  skip_before_action :authenticate_user!, raise: false

  def create
    @lead = Lead.new(lead_params)
    @lead.ip_address = request.remote_ip

    if @lead.company_url.present?
      redirect_to thanks_path
      return
    end

    if @lead.save
      LeadMailer.new_lead(@lead).deliver_later
      LeadMailer.auto_reply(@lead).deliver_later
      redirect_to thanks_path, notice: "Message sent successfully."
    else
      render template: "public/index", status: :unprocessable_entity
    end
  end

  def thanks
  end

  private

  def lead_params
    params.require(:lead).permit(:name, :email, :company, :message, :company_url)
  end
end
