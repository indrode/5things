# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # display default cancel button (must be inside div.buttons for correct styles)
  def cancel_button
    link_to raw("<img src=\"http://static.zenpunch.com/5things/images/cross.png\" alt=\"#{t("common.cancel")}\" width=\"16\" height=\"16\" />#{t("common.cancel")}"), root_path, :class => 'negative'
  end
  
  # create a random alphanumeric key
  def String.random_alphanumeric(size=16)
    s = ""
    size.times { s << (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61 ))).chr }
    s
  end
  
end
