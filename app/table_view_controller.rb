class TableViewController < UITableViewController
  include MotionListable::TableHelper

  attr_accessor :data_source
end
