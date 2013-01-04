# encoding: utf-8
module GroupBuysHelper
  def is_prepay_settlement?(product)
    if product && product[:is_prepay]
      is_prepay = true
      product.group_buys.each do |group_buy|
        is_prepay = false if group_buy[:settle_type] == '预付'
      end
    else
      is_prepay = false
    end
    is_prepay
  end

  def get_month_of_year_month(stat_date)
    Date.parse(stat_date + "-01").strftime("%m")
  end

  def group_buy_action_buttons(group_buy)
    if group_buy.id.nil?
      submit_tag('新增', :id => "btn_add_group",:class => "btn btn-primary")
    else
      buttons = ""
      content_tag :div, :class => 'action_bar' do
        submit_tag('修改', :id => "btn_update_group", :class => "btn btn-primary") +
        link_to(t('.destroy', :default => t("helpers.links.destroy")),
                  group_buy_path(group_buy),
                  :method => :delete,
                  :data => { :confirm => t('.confirm', :default => t("helpers.links.confirm", :default => 'Are you sure?')) },
                  :class => 'btn btn-primary btn-danger')
      end
    end
  end

  def render_new_group_buy(form, current_product, group_buy)
     html_content = ""
     if current_product
        if is_prepay_settlement?(current_product)
          html_content << content_tag(:div, "点击新增一条预存结算记录")
          html_content << hidden_field_tag('is_prepay', true)
        else
          html_content << form.input(:settle_nums, :label => "结算份数")
          html_content << form.input(:refund_nums, :label => "退款份数")
          html_content << form.input(:dsr, :label => "DSR评分")
          html_content << form.input(:stat_op_date, :label => "结算操作时间", :as => :string, :input_html => {:class => 'datepicker'})
        end
        html_content << group_buy_action_buttons(group_buy)
      end
      html_content.html_safe
  end

end
