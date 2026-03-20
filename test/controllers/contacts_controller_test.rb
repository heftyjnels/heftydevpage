require "test_helper"

class ContactsControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  def valid_lead_params
    {lead: {name: "Jane Doe", email: "jane@example.com", company: "Acme Corp", message: "I need a multi-tenant SaaS app."}}
  end

  test "creates lead and redirects to thanks" do
    assert_difference "Lead.count", 1 do
      post contacts_url, params: valid_lead_params
    end
    assert_redirected_to thanks_url
  end

  test "enqueues notification and auto-reply emails" do
    assert_enqueued_emails 2 do
      post contacts_url, params: valid_lead_params
    end
  end

  test "records ip address on lead" do
    post contacts_url, params: valid_lead_params
    lead = Lead.last
    assert_not_nil lead.ip_address
  end

  test "rejects spam via honeypot silently" do
    assert_no_difference "Lead.count" do
      post contacts_url, params: {lead: valid_lead_params[:lead].merge(company_url: "http://spam.com")}
    end
    assert_redirected_to thanks_url
  end

  test "re-renders form on invalid submission" do
    assert_no_difference "Lead.count" do
      post contacts_url, params: {lead: {name: "", email: "", message: ""}}
    end
    assert_response :unprocessable_entity
  end

  test "thanks page renders successfully" do
    get thanks_url
    assert_response :success
  end
end
