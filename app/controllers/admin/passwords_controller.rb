require "action_view"

class Admin::PasswordsController < Admin::AdminController
  helper_method :sort_column, :sort_order

  def index
      @passwords = Password.search(params[:search]).page(params[:page]).order(sort_column + " " + sort_order)
  end

  def show
    @password = Password.find_by_id(params[:id])

    if @password.nil?
      flash[:type] = "error"

      flash[:notice] = t "flash.password.error.could_not_find"

      redirect_to admin_passwords_url and return
    end
  end

  def new
    @password = Password.new
  end

  def create
    @password = Post.new(params[:password])

    unless @password.nil?
      @password.user = @current_user

      if @password.save
        flash[:type] = "success"

        flash[:notice] = t "flash.password.success.created", :password_name => @password.name, :undo_link => undo_link

        redirect_to admin_passwords_url and return
      else
        flash[:type] = "error"

        flash[:notice] = validation_errors_for(@password)

        render :action => :new and return
      end
    else
      flash[:type] = "error"

      flash[:notice] = t "flash.password.error.could_not_create"

      redirect_to new_admin_password_url and return
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

  def destroy_multiple
    if params[:passwords_ids].nil?
      flash[:type] = "error"

      flash[:notice] = t "flash.password.error.could_not_find_multiple"

      redirect_to admin_passwords_url and return
    end

    @passwords = Password.find_all_by_id(params[:passwords_ids])

    unless @passwords.nil?
      flash[:type] = "success"

      @passwords.each do |password|
        Password.destroy(password)

        unless flash[:notice].blank?
          flash[:notice] += "<br />"
        end

        flash[:notice] += t "flash.password.success.destroyed", :password_name => password.name, :undo_link => ""
      end

      redirect_to admin_passwords_url and return
    else
      flash[:type] = "error"

      flash[:notice] = t "flash.password.error.could_not_find_multiple"

      redirect_to admin_passwords_url and return
    end
  end

  private

  def sort_column
    Password.column_names.include?(params[:sort]) ? params[:sort] : "id"
  end

  def sort_order
    ["asc", "desc"].include?(params[:order]) ? params[:order] : "asc"
  end

  def undo_link
    view_context.link_to(t("flash.versions.undo"), revert_version_path(@password.versions.scoped.last), :method => :post)
  end
end
