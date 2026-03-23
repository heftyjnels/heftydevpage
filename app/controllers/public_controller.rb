class PublicController < ApplicationController
  layout "marketing", only: [:index]

  def index
    Current.meta_tags.set(
      title: "Rails MVP Developer | Pre-Seed SaaS | Heftydev",
      description: "Ship a pre-seed Rails MVP with payments, multitenancy, OAuth, notifications, email, and 2FA. Senior engineer hardening AI-accelerated delivery. Legal tech, fund admin, insurtech. $175/hr.",
      og_type: "website",
      twitter_type: "summary_large_image"
    )
  end

  def about
  end

  def terms
    @agreement = Rails.application.config.agreements.find { it.id == :terms_of_service }
  end

  def privacy
    @agreement = Rails.application.config.agreements.find { it.id == :privacy_policy }
  end

  def reset_app
    render html: "Redirecting...", layout: true
  end
end
