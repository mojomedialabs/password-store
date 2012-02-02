require "highline"
require "highline/import"
require "RFC2822"

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

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

=begin
def prompt_for_admin_email
  email = ask("E-mail Address: ", String) do |q|
    q.echo = true
    q.validate = RFC2822::EmailAddress
    q.responses[:not_valid] = "Invalid e-mail address. Must be a valid e-mail address."
    q.whitespace = :strip
  end

  email = "admin@teamrgc.com" if email.blank?
  email
end

def prompt_for_admin_password
  password = ask("Password: ", String) do |q|
    q.echo = false
    q.validate = /^([\x20-\x7E]){6,255}$/
    q.responses[:not_valid] = "Invalid password. Must be between 6 and 255 characters."
    q.whitespace = :strip
  end

  password = "assessments" if password.blank?
  password
end
=end

def create_admin_user
  puts "Create the admin user (press enter for defaults)."
  email = prompt_for_admin_field("E-mail Address: ", true, RFC2822::EmailAddress, "Invalid e-mail address. Must be a valid e-mail address.", "admin@teamrgc.com")
  password = prompt_for_admin_field("Password: ", false, /^([\x20-\x7E]){6,255}$/, "Invalid password. Must be between 6 and 255 characters.", "assessments")
  #email = prompt_for_admin_email
  #password = prompt_for_admin_password

  first_name = "Admin" #prompt_for_admin_field("First Name: ", true, "", "", "Admin")
  last_name = "User" #prompt_for_admin_field("Last Name: ", true, "", "", "User")
  street_address = "400 E. Las Colinas Blvd." #prompt_for_admin_field("Street Address: ", true, "", "", "400 E. Las Colinas Blvd.")
  city = "Irving" #prompt_for_admin_field("City: ", true, "", "", "Irving")
  zipcode = "75039" #prompt_for_admin_field("Zipcode: ", true, "", "", "75039")
  state = "TX" #prompt_for_admin_field("State: ", true, "", "", "TX")
  phone_number = "972-815-1070" #prompt_for_admin_field("Phone Number: ", true, /^(?:\+?1[-. ]?)?\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$/, "Invalid phone number.", "972-815-1070")

  attributes = {
    :email_address => email,
    :email_address_confirmation => email,
    :password => password,
    :password_confirmation => password,
    :first_name => first_name,
    :last_name => last_name,
    :street_address => street_address,
    :city => city,
    :zipcode => zipcode,
    :state => state,
    :phone_number => phone_number,
    :privilege_level => 4,
    :login_count => 0,
    :post_count => 0
  }

  load "user.rb"

  if User.find_by_email_address(email)
    puts "\nWARNING: There is already a user with the e-mail address: #{email}, so no account changes were made.\nIf you wish to create an additional admin user, please run rake db:seed again and enter a different e-mail address.\n\n"
  else
    admin = User.create(attributes)
    admin.save
  end
end

create_admin_user unless User.find_by_privilege_level(4)