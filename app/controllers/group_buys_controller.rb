# encoding: utf-8
class GroupBuysController < ApplicationController
    def index
      @group_buy = get_group_buy(params[:id])
      if @group_buy.new_record?
        product_name = params[:product_name]
        @stat_date = parse_stat_date_string(params[:stat_date])
        @current_product = get_product(product_name)
      else
        @current_product = @group_buy.product
        product_name = @current_product.name
        @stat_date = @group_buy.stat_date
      end
      @total_product_list = get_product_list()

      @presenter = GroupBuys::IndexPresenter.new(@stat_date, @current_product)
      @group_buys = @presenter.get_stat_records(params[:page], 10)
    end

    def create
      group_buy_record = GroupBuy.new params[:group_buy]
      if group_buy_record.save
        redirect_to :back, :notice => '成功创建结算记录.' 
      else
        render :index
      end
    end

    # PUT /businesses/1
    # PUT /businesses/1.json
    def update
      @group_buy = GroupBuy.find(params[:id])

      respond_to do |format|
        if @group_buy.update_attributes(params[:group_buy])
          format.html { redirect_to :back, notice: '团购结算记录更新成功!' }
          format.json { head :no_content }
        else
          format.html { redirect_to :back }
          format.json { render json: @group_buy.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /businesses/1
    # DELETE /businesses/1.json
    def destroy
      @group_buy = GroupBuy.find(params[:id])
      @group_buy.destroy

      respond_to do |format|
        format.html { redirect_to group_buys_url }
        format.json { head :no_content }
      end
    end

    def confirm_record
      groupbuy_id_list = JSON.parse(params[:groupbuy_id_list])
      settle_state = params[:confirm_flag] == "true"? "已处理" : "未处理"

      if groupbuy_id_list.blank? || groupbuy_id_list.length <= 0
        render :json => {nothing: true}
      else
        result = GroupBuy.where(id: groupbuy_id_list).update_all(state: settle_state)
        if result
            render :json => groupbuy_id_list
        else
            render :json => result.errors
        end
      end
    end

    def export_finance_records
      id_list = params[:id_list].split(',')
      settle_records = GroupBuy.includes(:product).find(id_list)

      export_content = ""
      settle_records.each_with_index do |record, index|
        partner = record.product.partner
        result = {:bank_acct => partner.bank_acct.slice(-4,4),
          :settle_money => record.settle_money,
          :online_date => record.product.begin_date,
          :product_name => record.product_name,
          :platform => record.product.platform,
          :nth_record => record.product_index,
          :fina_contact_phone => partner.fina_contact_phone }
        export_content << result.values.join("\t") + "\n"
      end
      file_name = "财务打款导出列表_" + DateTime.now.strftime('%Y%m%d%H%M%S') + ".txt"
      export_txt_file(file_name, export_content) 
    end

    private
    def get_product_list
      Product.all
    end

    def get_group_buy(id)
      if id.blank?
        GroupBuy.new 
      else
        GroupBuy.find(id)
      end
    end

    def get_product(product_name)
      if product_name.blank?
        nil
      else
        Product.find_by_name(product_name)
      end
    end

    def export_txt_file(name, content)
      send_data content,
        :type => 'text',
        :disposition => "attachment; filename=#{name}"   
    end
end
