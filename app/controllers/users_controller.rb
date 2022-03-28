class UsersController < ApplicationController
  before_action :set_user, only: %i[edit update destroy]
  before_action :set_users, only: %i[index search]

  def index
    users_with_criteria(params[:sort_by], params[:order])
  end

  def search
    users_with_criteria(params[:sort_by], params[:order])
  end

  def new
    @user = User.new

    respond_to do |format|
      format.js
    end
  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.js { flash.now[:notice] = 'User was successfully created.'}
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
        format.js { render :error }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.js { flash.now[:notice] = 'User was successfully updated.'}
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
        format.js { render :error }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
      format.js { flash.now[:notice] = 'User was successfully destroyed.'}
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def set_users
    @users = User.all
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :salary)
  end

  def users_with_criteria(sort_by, order)
    if sort_by.nil? && order.nil?
      @users
    else
      @sort_by = sort_by
      @order = order
      @users = @users.order("#{sort_by} #{order}")
    end
  end
end
