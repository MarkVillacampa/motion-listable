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
              textLabel: { text: "UITableViewCellEditingStyleDelete" },
              editingStyle: UITableViewCellEditingStyleDelete,
              on_delete: proc {}
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
              ],
              editingStyle: UITableViewCellEditingStyleDelete
            }
          ]
        }
      ]
    }
    self.controller.data_source = @data_source
  end

  tests TableViewController

  it "should call on_insert callback" do
    controller.tableView.editing = true
    cell = controller.tableView.cell_at_index([0,0])
    tap(cell, at: :left)
    @data_source[:sections].first[:cells][0][:on_insert].should.be.called
  end

  it "should call on_delete callback" do
    controller.tableView.editing = true
    cell = controller.tableView.cell_at_index([0,1])
    tap(cell, at: :left)
    wait 0.5 do
      point = CGPointMake(controller.view.frame.size.width - 20, cell.frame.origin.y + 20)
      tap(cell, at: point)
      wait 0.5 do
        @data_source[:sections].first[:cells][1][:on_delete].should.be.called
      end
    end
  end

end
