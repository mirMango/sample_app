require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
  end

  test "password resets" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    assert_select 'input[name=?]', 'password_reset[email]'
    
    # Invalid email
    post password_resets_path, params: { password_reset: { email: "" } }
    assert_not flash.empty?
    assert_template 'password_resets/new'
    
    # Valid email
    post password_resets_path, params: { password_reset: { email: @user.email } }
    old_digest = @user.reset_digest
    puts "Old reset digest: #{old_digest}" # Debug output
    @user.reload
    new_digest = @user.reset_digest
    puts "New reset digest: #{new_digest}" # Debug output
    assert_not_equal old_digest, new_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    
    # Password reset form
    user = assigns(:user)
    
    # Wrong email
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_url
    
    # Inactive user
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)
    
    # Right email, wrong token
    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url
    
    # Right email, right token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email
    
    # Invalid password & confirmation
    patch password_reset_path(user.reset_token), params: { email: user.email,
      user: { password: "foobaz", password_confirmation: "barquux" } }
    assert_select 'div#error_explanation'
    
    # Empty password
    patch password_reset_path(user.reset_token), params: { email: user.email,
      user: { password: "", password_confirmation: "" } }
    assert_select 'div#error_explanation'
    
    # Valid password & confirmation
    patch password_reset_path(user.reset_token), params: { email: user.email,
      user: { password: "foobaz", password_confirmation: "foobaz" } }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end
end
