require "highline"
require "highline/import"
require "RFC2822"
require "active_record/fixtures"

def prompt_for_admin_field(prompt, echo, validate, validate_response, default)
  field = ask(prompt) do |q|
    q.echo = echo
    unless validate.blank?
      q.validate = validate
      q.responses[:not_valid] = validate_response
    end
    q.whitespace = :strip
  end

  field = default if field.blank?
  field
end

def create_admin_user
  puts "Create the admin user (press enter for defaults)."
  email = prompt_for_admin_field("E-mail Address: ", true, RFC2822::EmailAddress, "Invalid e-mail address. Must be a valid e-mail address.", "admin@teamrgc.com")
  password = prompt_for_admin_field("Password: ", false, /^([\x20-\x7E]){6,255}$/, "Invalid password. Must be between 6 and 255 characters.", "assessments")

  first_name = "Admin"
  last_name = "User"
  phone_number = "972-815-1070"

  attributes = {
    :email_address => email,
    :email_address_confirmation => email,
    :password => password,
    :password_confirmation => password,
    :first_name => first_name,
    :last_name => last_name,
    :phone_number => phone_number,
    :privilege_level => 4,
    :login_count => 0,
  }

  if User.find_by_email_address(email)
    puts "\nWARNING: There is already a user with the e-mail address: #{email}, so no account changes were made.\nIf you wish to create an additional admin user, please run rake db:seed again and enter a different e-mail address.\n\n"
  else
    admin = User.create(attributes)
    admin.save
  end
end

load "user.rb"

create_admin_user unless User.find_by_privilege_level(4)

seed_users = YAML::load_file(File.join(Rails.root, "db", "fixtures", "users.yml"))
seed_users["users"].each do |user|
  new_user = User.create(user)
  new_user.save
end