class PasswordsController < ApplicationController
  before_filter :ensure_login

  def index
    #@passwords = @current_user.passwords.search(params[:search]).page(params[:page]).order(sort_column + " " + sort_order)
    @passwords = Password.all
  end

  def show
    @password = Password.find_by_id(params[:id])

    if @password.nil? or @password.user != @current_user
      flash[:type] = "error"

      flash[:notice] = t "flash.password.error.could_not_find"

      redirect_to root_url and return
    end
  end

  def new
    @password = Password.new
  end

  def create
    @password = Password.new(params[:password])

    #@password.encrypt

    flash[:debug] = @password

    redirect_to root_url and return


    unless @password.nil?
      @password.user = @current_user

      if @password.save
        flash[:type] = "success"

        flash[:notice] = t "flash.password.success.created", :password_name => @password.name, :undo_link => undo_link

        redirect_to root_url and return
      else
        flash[:type] = "error"

        flash[:notice] = validation_errors_for(@password)

        render :action => :new and return
      end
    else
      flash[:type] = "error"

      flash[:notice] = t "flash.password.error.could_not_create"

      redirect_to new_password_url and return
    end
  end

  def edit
    @password = Password.find_by_id(params[:id])

    if @password.nil?
      flash[:type] = "error"

      flash[:notice] = t "flash.password.error.could_not_find"

      redirect_to admin_passwords_url and return
    end
  end

  def update
    @password = Password.find_by_id(params[:id])

    unless @password.nil?
      if @password.update_attributes(params[:password])
        flash[:type] = "success"

        flash[:notice] = t "flash.password.success.updated", :password_name => @password.name, :undo_link => undo_link

        redirect_to admin_password_url(@password) and return
      else
        flash[:type] = "error"

        flash[:notice] = validation_errors_for(@password)

        render :action => :edit and return
      end
    else
      flash[:type] = "error"

      flash[:notice] = t "flash.password.error.could_not_find"

      redirect_to admin_passwords_url and return
    end
  end

  def destroy
    @password = Password.find_by_id(params[:id])

    unless @password.nil?
      Password.destroy(@password)

      flash[:type] = "success"

      flash[:notice] = t "flash.password.success.destroyed", :password_name => @password.name, :undo_link => undo_link

      redirect_to admin_passwords_url and return
    else
      flash[:type] = "error"

      flash[:notice] = t "flash.password.error.could_not_find"

      redirect_to admin_passwords_url and return
    end
  end

  def sort_column
    Password.column_names.include?(params[:sort]) ? params[:sort] : "id"
  end

  def sort_order
    ["asc", "desc"].include?(params[:order]) ? params[:order] : "asc"
  end

  def undo_link
    #view_context.link_to(t("flash.versions.undo"), revert_version_path(@password.versions.scoped.last), :method => :post)
    ""
  end
end
