class PayMethodsController < ApplicationController
  before_action :set_pay_method, only: [:show, :edit, :update, :destroy]
  before_action :get_user

  # GET /users/:id/payMethods
  def index
    @pay_methods = PayMethods.where('user_id = ?',current_user.id)
    @scaduti=[]
    i=0
    @pay_methods.each do |pay|
      @scaduti[i] = pay_scaduto(pay)
      i+=1
    end
  end

  # GET /users/:id/payMethods/:id
  def show
    @scaduto = pay_scaduto(@pay_method)
  end

  # GET /users/:id/payMethods/new
  def new
    @pay_method = PayMethods.new
    session[:return_to_pay] ||= request.referer
  end

  # GET /users/:id/payMethods/edit
  def edit
  end

  # POST /users/:id/payMethods/
  def create
    @pay_method = PayMethods.new(pay_params)

    respond_to do |format|
      if @pay_method.save
        format.html { redirect_to (session.delete(:return_to_pay)|| user_pay_methods_path(@user)), notice: 'Pay method was successfully created.' }
        format.json { render :show, status: :created, location: @pay_method }
      else
        format.html { render :new }
        format.json { render json: @pay_method.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vehicles/1
  # PATCH/PUT /vehicles/1.json
  def update
    respond_to do |format|
      if @pay_method.update(pay_params)
        format.html { redirect_to user_pay_methods_path(@pay_method), notice: 'Vehicle was successfully updated.' }
        format.json { render :show, status: :ok, location: @pay_method }
      else
        format.html { render :edit }
        format.json { render json: @pay_method.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vehicles/1
  # DELETE /vehicles/1.json
  def destroy
    @pay_method.destroy
    respond_to do |format|
      format.html { redirect_to user_pay_methods_path(@pay_method), notice: 'Vehicle was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_pay_method
    @pay_method = PayMethods.find(params[:id])
  end

  def get_user
    @user = User.find(current_user.id)
  end

  # Only allow a list of trusted parameters through.
  def pay_params
    params.require(:pay_methods).permit(:intestatario, :numero, :mese_scadenza, :anno_scadenza, :cvv, :user_id)
  end

  def pay_scaduto(pay)
    time = Time.new
    anno = pay.anno_scadenza + 2000
    if anno < time.year
      return true
    elsif anno == time.year && pay.mese_scadenza < time.month
      return true
    else
      return false
    end
  end

end
