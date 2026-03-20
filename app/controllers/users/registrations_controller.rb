class Users::RegistrationsController < Devise::RegistrationsController
  ALLOWED_EMAILS = %w[trevorjohnnels@gmail.com].freeze

  invisible_captcha only: :create
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_user_registration_path, alert: I18n.t("try_again_later") }

  before_action :check_email_whitelist, only: :create, unless: -> { Rails.env.test? }

  protected

  def build_resource(hash = {})
    self.resource = resource_class.new_with_session(hash, session)

    if params[:invite] && (invite = AccountInvitation.find_by(token: params[:invite]))
      @account_invitation = invite
      resource.name ||= invite.name
      resource.email = resource.email.presence || invite.email
    elsif Jumpstart.config.register_with_account?
      resource.owned_accounts.first || resource.owned_accounts.new
    end
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def sign_up(resource_name, resource)
    super

    refer(resource) if defined? Refer

    if @account_invitation
      current_user.accounts.where(personal: false).destroy_all
      @account_invitation.accept!(current_user)
      stored_location_for(:user)
    end
  end

  private

  def check_email_whitelist
    email = sign_up_params[:email].to_s.downcase.strip
    return if ALLOWED_EMAILS.include?(email)

    self.resource = resource_class.new(sign_up_params)
    resource.validate
    resource.errors.add(:email, "is not authorized to register")
    respond_with resource
  end
end
