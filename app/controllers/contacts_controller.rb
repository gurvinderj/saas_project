class ContactsController < ApplicationController
  
  # GET request to /contact-us
  # Show new contact form 
    def new
      @contact = Contact.new
    end
    
  # POST request /contacts 
  def create
    @contact = Contact.new(contact_params) 
    # Mass assignment of form fields into Contact object
    if @contact.save
      # Save the Contact object into the database
      # Store form fields via parameters, into variables
       name = params[:contact][:name]
       email = params[:contact][:email]
       body = params[:contact][:comments]
       # Plug variables into Contact Mailer method and send email
       ContactMailer.contact_email(name, email, body).deliver
       # Store success message in flash has and redirect to new action
       flash[:success] = "Message sent."
       redirect_to new_contact_path
    else
      # If Contact object does not save
      # store errors in flash hash
      # and redirect to new action
       flash[:danger] = @contact.errors.full_messages.join(", ")
       redirect_to new_contact_path
    end
  end
  private
    # To collect data from form we need to use 
    # strong parameters and whitelist form fields
    def contact_params
       params.require(:contact).permit(:name, :email, :comments)
    end
end