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

      back_url = group_buys_path + "?stat_date=" + @group_buy.created_at.to_date.strftime('%Y-%m')
      back_url += "&product_name=" +  URI.escape(@group_buy.product_name)

      if !params[:group_buy][:settle_nums].blank?
        params[:group_buy][:settle_money] = params[:group_buy][:settle_nums].to_i * @group_buy.product.settle_price
      end

      respond_to do |format|
        if @group_buy.update_attributes(params[:group_buy])
          format.html { redirect_to back_url, notice: '团购结算记录更新成功!' }
          format.json { head :no_content }
        else
          format.html { redirect_to back_url }
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
      confirm_flag =  params[:confirm_flag]

      if confirm_flag == "true"
        settle_state = "已处理"
      else
        settle_state = "未处理"
      end

      if !groupbuy_id_list.blank?
        hanlded_id_list = []
        result = GroupBuy.find(groupbuy_id_list).each do |group_buy|
          group_buy.state = settle_state
          group_buy.save
          hanlded_id_list << group_buy.id
        end
        respond_to do |format|
          format.html do
            redirect_to :back 
          end
          format.json { render :json => hanlded_id_list.as_json }
          format.js { render :nothing => true }
        end
      else
       redirect_to :back 
      end
    end

    def export_finance_records
      id_list = params[:id_list].split(',')
      settle_records = GroupBuy.find id_list

      exported_results = []
      nth_record = 0
      settle_records.each do |record|
        product_records = GroupBuy.where('product_name = ?', record.product_name).order('stat_op_date')
        product_records.each_with_index do |r, i|
          if record.id == r.id    
            nth_record = i + 1
          end
        end

        result = {:bank_acct => record.product.partner.bank_acct.slice(-4,4),
          :settle_money => record.settle_money,
          :online_date => record.product.begin_date,
          :product_name => record.product_name,
          :platform => record.product.platform,
          :nth_record => nth_record,
          :fina_contact_phone => record.product.partner.fina_contact_phone }

        exported_results << result
      end

      export_content = ""
      exported_results.each do |result|
        export_content << result.values.join("\t") + "\n"
      end

      file_name = "财务打款导出列表_" + DateTime.now.strftime('%Y%m%d%H%M%S') + ".txt"
      send_data export_content,
        :type => 'text',
        :disposition => "attachment; filename=#{file_name}"
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

end
