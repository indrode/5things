module TasksHelper
  
  def report_include_completed?(a)
    Array[ 1, 3, 5, 7 ].include?(a)
  end
  
  def report_include_unassigned?(a)
    Array[ 2, 3, 6, 7 ].include?(a)
  end
  
  def report_include_empty?(a)
    Array[ 4, 5, 6, 7 ].include?(a)
  end
  
end