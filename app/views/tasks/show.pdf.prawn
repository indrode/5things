# uses the awesomeness that is prawn and prawnto to create PDF reports
# http://prawn.majesticseacreature.com/
# http://cracklabs.com/prawnto

pdf.text @tasklist.title, :size => 20, :style => :bold
#pdf.text @today.to_s, :size => 14, :style => :bold
pdf.text " "
pdf.text @tasklist.description

curdate = @today

# display items grouped by day
unless @items_by_month.blank?
  
@items_by_month.each do |duedate, items|
  
  
  # include empty days (env_reporting)
  if report_include_empty?(@tasklist.reporting)
    while duedate.to_date >= curdate.to_date
      pdf.text " "
    	pdf.text l curdate.to_date, :format => :long
    	curdate = curdate.tomorrow
    end
  else
    pdf.text " "
  	pdf.text l duedate.to_date, :format => :long  
  end  
  
  # display items
  dailies = items.map do |item|  
    [  
          item.body,  
          item.completed == true  ? 'X' : ' '
    ]  
  end
  
  pdf.table dailies, :border_style => :grid,  
      :row_colors => ["FFFFFF", "DDDDDD"],  
      :column_widths => { 0 => 400, 1 => 80},
      :align => { 0 => :left, 1 => :center}
end

end


# include unassigned tasks (env_reporting)
if report_include_unassigned?(@tasklist.reporting)
  unless @unassigned.blank?
  pdf.text " "
  pdf.text "Unassigned Tasks"
  
  dailies = @unassigned.map do |item|  
    [  
          item.body,  
          item.completed == true  ? 'X' : ' '
    ]  
  end
  
  pdf.table dailies, :border_style => :grid,  
    :row_colors => ["FFFFFF", "DDDDDD"],  
    :column_widths => { 0 => 400, 1 => 80},
    :align => { 0 => :left, 1 => :center}
  end
end