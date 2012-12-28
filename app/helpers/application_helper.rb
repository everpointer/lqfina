# encoding: utf-8
module ApplicationHelper
    def controller_stylesheet_link_tag
        case controller_name
        when "group_buys", "products", "partners", "businesses"
          stylesheet_link_tag controller_name
        end
    end

    def environment_javascript_include_tag
        # if Rails.env.production?
        #     javascript_include_tag "lq_production_config"
        # else
        #     javascript_include_tag "lq_config"
        # end
    end
    
    def controller_javascript_include_tag
        case controller_name
        when "group_buys", "products", "partners", "businesses"
          javascript_include_tag controller_name
        end
    end

    def convert_boolean_cn(b_origin)
        if b_origin
            "是"
        else
            "否"
        end
    end

    def render_notice
    if flash[:notice]
      content_tag(:div,  flash[:notice], :class => "message notice")
    end
  end

  def render_warning
    if flash[:warning]
      content_tag(:div,  flash[:alert], :class => "message alert")
    end
  end
end