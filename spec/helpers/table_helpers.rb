class Array
  def to_index
    NSIndexPath.indexPathForRow(self[1], inSection:self[0])
  end
end

class UITableView
  def cell_at_index(index)
    cellForRowAtIndexPath(index.to_index)
  end
end
