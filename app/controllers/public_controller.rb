class PublicController < ApplicationController
  layout "marketing", only: [:index]

  def index
    Current.meta_tags.set(
      title: "Rails Consulting for Complex Multi-Tenant SaaS",
      description: "Senior Rails engineer specializing in legal tech, private capital, and insurance SaaS. Multi-tenant apps, billing, KYC, and document workflows. $175/hr.",
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
