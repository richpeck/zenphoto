##########################################
##########################################
##       _____               __         ##
##      / ___/___  ___  ____/ /____     ##
##      \__ \/ _ \/ _ \/ __  / ___/     ##
##     ___/ /  __/  __/ /_/ (__  )      ##
##    /____/\___/\___/\__,_/____/       ##
##                                      ##
##########################################
##########################################

# => SuperAdmin
# => User ID 0 is always superadmin, and we want to create them without any issues
@user = User.create_with(password: ENV.fetch('ADMIN_PASS'), profile_attributes: { role: :super_admin }).find_or_create_by! email: ENV.fetch('ADMIN_EMAIL')  # => password omitted means the system will send the password via email

##########################################
##########################################

# => Meta
# => These allow us to create data objects which do not require the files to be created
# => Only really meant as a data-store
%w(option).each do |meta|
  @user.nodes.create ref: "meta", val: meta  # => Bang operator raises errors
end

##########################################
##########################################

# => Options
# => Allows us to store various options inside the "Option" table
# => Make sure we're using the new @user object we created
@user.options.create_with(val: "Notion (App)").find_or_create_by! ref: "app_title" if @user.try(:options)

##########################################
##########################################
