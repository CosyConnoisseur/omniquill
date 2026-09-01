module ApplicationHelper

  def home_button_data
    if current_page?(root_path)
      { turbo_action: "replace" }
    else
      { direction: "back" }
    end
  end

end
