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

  def get_industry_types
    [
      { id: 1, name: "餐饮美食"},
      { id: 2, name: "教育培训"},
      { id: 3, name: "水果生鲜"},
      { id: 4, name: "通讯话费"},
      { id: 5, name: "生活服务"},
      { id: 6, name: "休闲娱乐"},
      { id: 7, name: "旅游酒店"},
      { id: 8, name: "电影"},
      { id: 9, name: "摄影写真"}
    ]
  end

  def get_industry_type_name(id)
    types = get_industry_types
    for type in types
      if id == type[:id]
        name = type[:name]
        break
      end
    end
    name
  end

  def hidden_tag(tag)
    content_tag :span, "", value: tag[:value], id: tag[:id], class: "hidden"
  end
end