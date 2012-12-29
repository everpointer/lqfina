# encoding: utf-8
class BusinessesController < ApplicationController
  # GET /businesses
  # GET /businesses.json
  def index
    @businesses = Business.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @businesses }
    end
  end

  # GET /businesses/1
  # GET /businesses/1.json
  def show
    @business = Business.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @business }
    end
  end

  # GET /businesses/new
  # GET /businesses/new.json
  def new
    @business = Business.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @business }
    end
  end

  # GET /businesses/1/edit
  def edit
    @business = Business.find(params[:id])
  end

  # POST /businesses
  # POST /businesses.json
  def create
    @business = Business.new(params[:business])

    respond_to do |format|
      if @business.save
        format.html { redirect_to @business, notice: 'Business was successfully created.' }
        format.json { render json: @business, status: :created, location: @business }
      else
        format.html { render action: "new" }
        format.json { render json: @business.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /businesses/1
  # PUT /businesses/1.json
  def update
    @business = Business.find(params[:id])

    respond_to do |format|
      if @business.update_attributes(params[:business])
        format.html { redirect_to @business, notice: 'Business was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @business.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /businesses/1
  # DELETE /businesses/1.json
  def destroy
    @business = Business.find(params[:id])
    @business.destroy

    respond_to do |format|
      format.html { redirect_to businesses_url }
      format.json { head :no_content }
    end
  end

  def stat
    @business = Business.find(params[:id])
    @busi_stat_records = @business.business_stat_records.sort { |a,b| b[:stat_date] <=> a[:stat_date] }

    @current_stat_date = params[:stat_date]

    if @current_stat_date =~ /\d{4}-(((0[1-9])|(1[0-2])))/
      @product_stat_result = []

      busi_begin_date = @current_stat_date + "-01"
      busi_end_date = busi_begin_date.to_date.end_of_month.to_s

      group_buy_begin_date = busi_begin_date.to_date.next_month.to_s
      group_buy_end_date = busi_begin_date.to_date.next_month.end_of_month.to_s

      @business.partners.each do |partner|
        # products = partner.products.where('begin_date >= ? and begin_date <= ?', busi_begin_date, busi_end_date)
        products = partner.products.where('begin_date <= ? and end_date >= ?', busi_end_date, busi_begin_date)
        products.each do |product|

          selled_price = product.selled_price
          settle_price = product.settle_price
          # group_buys = product.group_buys.where('created_at >= ? and created_at <= ? and settle_type != ?', group_buy_begin_date, group_buy_end_date, '预付')
          group_buys = product.group_buys.where('stat_op_date >= ? and stat_op_date <= ? and settle_type != ? and state = ?', group_buy_begin_date, group_buy_end_date, '预付', '已处理')

          if group_buys.length > 0
            settle_nums = group_buys[0][:settle_nums]
            dsr = group_buys[0][:dsr]
            dsr_rate =  if dsr < 4.0
              0
            elsif dsr >= 4.0 && dsr < 4.3
              0.5
            elsif dsr >= 4.3 && dsr < 4.5
              0.8
            else
              1
            end

            # 业务员提成计算公式: (团购 - 结算金额 -1元码费) / 4 * dsr动态评分
            bonus = (selled_price - settle_price - 1) * settle_nums / 4 * dsr_rate
            @product_stat_result << {:product_name => product.name, :bonus => bonus}
          end
        end  # end of product
      end # end of partner
    end

    def create_stat
      @business = Business.find(params[:id])

      stat_date = params[:stat_date]
      bonus = params[:bonus].to_f

      busi_stat_record = BusinessStatRecord.create :business_id => @business.id, :stat_date => stat_date, :bonus => bonus

      if busi_stat_record
        redirect_to :action => 'stat', :id => params[:id]
      else
        redirect_to :back, :flash => { :error => "添加业务结算记录失败" }
      end
    end

  end
end
