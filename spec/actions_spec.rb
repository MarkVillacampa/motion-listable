describe "Actions" do
  before do
    @data_source = {
      sections: [
        {
          cells: [
            {
              textLabel: { text: "UITableViewCellEditingStyleInsert" },
              editingStyle: UITableViewCellEditingStyleInsert,
              on_insert: proc {}
            },
            {
              textLabel: { text: "UITableViewCellEditingStyleInsert" },
              editingStyle: UITableViewCellEditingStyleInsert,
              on_insert: :my_on_insert_callback
            },
            {
              textLabel: { text: "UITableViewCellEditingStyleDelete" },
              editingStyle: UITableViewCellEditingStyleDelete,
              on_delete: proc {}
            },
            {
              textLabel: { text: "UITableViewCellEditingStyleDelete" },
              editingStyle: UITableViewCellEditingStyleDelete,
              on_delete: :my_on_delete_callback
            },
            {
              textLabel: { text: "Default" },
              edit_actions: [
                UITableViewRowAction.rowActionWithStyle(UITableViewRowActionStyleDefault,
                  title:"Default", handler: proc { |action, index| p action }),
                UITableViewRowAction.rowActionWithStyle(UITableViewRowActionStyleDestructive,
                  title:"Destructive", handler: proc { |action, index| p action }),
                UITableViewRowAction.rowActionWithStyle(UITableViewRowActionStyleNormal,
                  title:"Normal", handler: proc { |action, index| p action })
              ]
            }
          ]
        }
      ]
    }
    self.controller.data_source = @data_source
  end

  tests TableViewController

  it "on_insert - should call the cell method" do
    controller.tableView.editing = true
    cell = controller.tableView.cell_at_index([0, 0])
    tap(cell, at: :left)
    cell.on_insert_called.should == true
  end

  it "on_insert - should call the proc" do
    controller.tableView.editing = true
    cell = controller.tableView.cell_at_index([0, 0])
    tap(cell, at: :left)
    @data_source[:sections].first[:cells][0][:on_insert].should.be.called
  end

  it "on_insert - should call the controller action method" do
    controller.tableView.editing = true
    controller.mock!(:my_on_insert_callback) { |cell_data, cell, indexPath| }
    cell = controller.tableView.cell_at_index([0, 1])
    tap(cell, at: :left)
  end

  it "on_insert - should call the controller default method" do
    controller.tableView.editing = true
    cell = controller.tableView.cell_at_index([0, 0])
    cell.mock!(:on_insert) { |cell_data, cell, indexPath| }
    tap(cell, at: :left)
  end


  it "on_delete - should call the cell method" do
    controller.tableView.editing = true
    cell = controller.tableView.cell_at_index([0, 2])
    tap(cell, at: :left)
    wait 0.1 do
      frame = cell.frame
      point = CGPointMake(CGRectGetMaxX(frame) - 20, CGRectGetMidY(frame))
      tap(cell, at: point)
      wait 0.1 do
        cell.on_delete_called.should == true
      end
    end
  end

  it "on_delete - should call the proc" do
    controller.tableView.editing = true
    cell = controller.tableView.cell_at_index([0, 2])
    tap(cell, at: :left)
    wait 0.1 do
      frame = cell.frame
      point = CGPointMake(CGRectGetMaxX(frame) - 20, CGRectGetMidY(frame))
      tap(cell, at: point)
      wait 0.1 do
        @data_source[:sections].first[:cells][2][:on_delete].should.be.called
      end
    end
  end

  it "on_delete - should call the controller action method" do
    controller.tableView.editing = true
    controller.mock!(:my_on_delete_callback) { |cell_data, cell, indexPath| }
    cell = controller.tableView.cell_at_index([0, 3])
    tap(cell, at: :left)
    wait 0.1 do
      frame = cell.frame
      point = CGPointMake(CGRectGetMaxX(frame) - 20, CGRectGetMidY(frame))
      tap(cell, at: point)
      wait 0.1 do
      end
    end
  end

  it "on_delete - should call the controller default method" do
    controller.tableView.editing = true
    cell = controller.tableView.cell_at_index([0, 2])
    cell.mock!(:on_delete) { |cell_data, cell, indexPath| }
    tap(cell, at: :left)
    wait 0.1 do
      frame = cell.frame
      point = CGPointMake(CGRectGetMaxX(frame) - 20, CGRectGetMidY(frame))
      tap(cell, at: point)
      wait 0.1 do
      end
    end
  end
end
