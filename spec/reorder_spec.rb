describe "Reordering cells" do
  before do
    @data_source = {
      sections: [
        {
          can_reorder: true,
          cells: [
            { textLabel: { text: "Movable cell 1" } },
            { textLabel: { text: "Movable cell 2" } }
          ]
        },
        {
          cells: [
            { textLabel: { text: "Non-movable cell" }, }
          ]
        }
      ]
    }
    self.controller.data_source = @data_source
    self.controller.tableView.editing = true
  end

  tests TableViewController

  it "shows reorder controls only for configured sections" do
    cell = controller.tableView.cell_at_index([0,0])
    cell.showsReorderControl.should ==  true
    cell = controller.tableView.cell_at_index([1,0])
    cell.showsReorderControl.should ==  false
    wait 3 {}
  end
end
