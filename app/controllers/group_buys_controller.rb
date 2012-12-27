# encoding: utf-8
class GroupBuysController < ApplicationController
    before_filter :init_variable, :only=>[:index]
    before_filter :init_product_list, :only=>[:index]
    before_filter :init_record_add_form, :only=>[:index]
    before_filter :init_stat_records, :only=>[:index]

    def index
    end

    def create
      groupbuy = {}
      groupbuy['product_name'] = params[:product_name]
      product = Product.find_by_name(groupbuy['product_name'])


      if params[:is_prepay] == "true"
        groupbuy['settle_type'] = "预付"
        groupbuy['settle_nums'] = product['selled_nums'] 
        groupbuy['settle_money'] = product['prepay_percentage'] * product['selled_nums'] * product['settle_price']
        groupbuy['real_settle_money'] = 0
      else
        groupbuy['settle_type'] = "结算"
        groupbuy['refund_nums'] = params[:group_buy][:refund_nums].to_i
        groupbuy['settle_nums'] = params[:group_buy][:settle_nums].to_i
        groupbuy['dsr'] = params[:group_buy][:dsr].to_f
        groupbuy['settle_money'] = groupbuy['settle_nums'] * product['settle_price']
        # 计算实际结算金额
        if !product.is_prepay
          groupbuy['real_settle_money'] = groupbuy['settle_nums'] * product['settle_price']
        else
          settle_group_buys = product.group_buys.select { |g| g['settle_type'] == '结算'}
          prepay_records = product.group_buys.select { |g| g['settle_type'] == '预付'}
          prepay_money = prepay_records[0]['settle_money']
          already_settled_money = 0
          settle_group_buys.each { |g| already_settled_money += g[:settle_money] }

          if already_settled_money >= prepay_money
            groupbuy['real_settle_money'] =  groupbuy['settle_money']
          elsif (already_settled_money + groupbuy['settle_money']) > prepay_money 
            groupbuy['real_settle_money'] = already_settled_money + groupbuy['settle_money'] - prepay_money
          else
            groupbuy['real_settle_money'] = 0
          end
        end
      end
      groupbuy['state'] = "未处理"

      GroupBuy.create groupbuy

      # redirect_to group_buys_path + "?product_name=#{params[:product_name]}&stat_date=#{params[:stat_date]}"
      redirect_to :back
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
          format.html { redirect_to back_url, notice: 'GroupBuy was successfully updated.' }
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
        product_records = GroupBuy.where('product_name = ?', record.product_name).order('created_at')
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

    def init_variable
      @current_product = Product.find_by_name(params[:product_name])

      if params[:stat_date].blank?
        @current_year_month = DateTime.now.strftime('%Y-%m')
      else
        @current_year_month = params[:stat_date]
      end
    end

    def init_product_list
      @total_product_list = Product.all
    end

    def init_record_add_form
      if params[:id].blank?
        @group_buy = GroupBuy.new 
      else
        @group_buy = GroupBuy.find(params[:id])
      end
    end

    def product_is_prepay?(product_name)
      if !product_name.blank?
        product = Product.where("name = ?", product_name).find(1)
        if product[:is_prepay]
          return true
        else
          return false
        end
      else
        return nil
      end
    end

    def init_stat_records
      clause = {}
      # if !params[:stat_date].blank?
        # Date can't parse 'yyyy-mm' format
      stat_date = Date.parse @current_year_month + "-01"

      begin_date = stat_date.beginning_of_month().strftime("%Y-%m-%d")
      end_date = stat_date.end_of_month().strftime("%Y-%m-%d")
      clause[:updated_at] = begin_date..end_date
      # end
      if !params[:product_name].blank?
        clause[:product_name] = params[:product_name]
      end

      if !clause.blank?
        @group_buys = GroupBuy.where(clause).order("product_name, updated_at desc")
      else
        @group_buys = GroupBuy.order("product_name, updated_at desc").all
      end
    end
end
