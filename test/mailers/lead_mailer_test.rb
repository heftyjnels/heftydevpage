require "test_helper"

class LeadMailerTest < ActionMailer::TestCase
  def setup
    @lead = Lead.new(
      name: "Jane Doe",
      email: "jane@example.com",
      company: "Acme Corp",
      message: "I need a multi-tenant SaaS app.",
      ip_address: "127.0.0.1"
    )
  end

  test "new_lead sends to support email" do
    mail = LeadMailer.new_lead(@lead)
    assert_equal [Jumpstart.config.support_email], mail.to
    assert_match "Jane Doe", mail.subject
    assert_match "Acme Corp", mail.subject
  end

  test "new_lead body contains lead details" do
    mail = LeadMailer.new_lead(@lead)
    assert_match "jane@example.com", mail.body.encoded
    assert_match "multi-tenant SaaS", mail.body.encoded
  end

  test "auto_reply sends to lead email" do
    mail = LeadMailer.auto_reply(@lead)
    assert_equal ["jane@example.com"], mail.to
    assert_match "Heftydev", mail.subject
  end

  test "auto_reply body contains lead name" do
    mail = LeadMailer.auto_reply(@lead)
    assert_match "Jane", mail.body.encoded
  end
end
