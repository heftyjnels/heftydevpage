require "test_helper"

class LeadTest < ActiveSupport::TestCase
  def valid_lead_attributes
    {name: "Jane Doe", email: "jane@example.com", message: "I need a multi-tenant SaaS app."}
  end

  test "valid with required attributes" do
    lead = Lead.new(valid_lead_attributes)
    assert lead.valid?
  end

  test "invalid without name" do
    lead = Lead.new(valid_lead_attributes.merge(name: nil))
    assert_not lead.valid?
    assert_not_empty lead.errors[:name]
  end

  test "invalid without email" do
    lead = Lead.new(valid_lead_attributes.merge(email: nil))
    assert_not lead.valid?
    assert_not_empty lead.errors[:email]
  end

  test "invalid without message" do
    lead = Lead.new(valid_lead_attributes.merge(message: nil))
    assert_not lead.valid?
    assert_not_empty lead.errors[:message]
  end

  test "invalid with badly formatted email" do
    lead = Lead.new(valid_lead_attributes.merge(email: "not-an-email"))
    assert_not lead.valid?
    assert_not_empty lead.errors[:email]
  end

  test "valid without company" do
    lead = Lead.new(valid_lead_attributes.merge(company: nil))
    assert lead.valid?
  end

  test "enforces name length limit" do
    lead = Lead.new(valid_lead_attributes.merge(name: "a" * 101))
    assert_not lead.valid?
    assert_not_empty lead.errors[:name]
  end

  test "enforces email length limit" do
    lead = Lead.new(valid_lead_attributes.merge(email: "#{"a" * 246}@test.com"))
    assert_not lead.valid?
    assert_not_empty lead.errors[:email]
  end

  test "enforces company length limit" do
    lead = Lead.new(valid_lead_attributes.merge(company: "a" * 201))
    assert_not lead.valid?
    assert_not_empty lead.errors[:company]
  end

  test "enforces message length limit" do
    lead = Lead.new(valid_lead_attributes.merge(message: "a" * 5001))
    assert_not lead.valid?
    assert_not_empty lead.errors[:message]
  end

  test "company_url is a virtual attribute for honeypot" do
    lead = Lead.new(valid_lead_attributes)
    lead.company_url = "http://spam.com"
    assert_equal "http://spam.com", lead.company_url
    assert lead.valid?
  end
end
