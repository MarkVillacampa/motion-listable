class TableViewController < UITableViewController
  include MotionIOSTable::TableHelper

  attr_accessor :data_source
end
