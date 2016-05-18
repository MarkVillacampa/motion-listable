# Because #on_create is called right after the UITableViewCell is instanciated,
# we cannot use #mock! to test it. Instead do this.
class UITableViewCell
  attr_accessor :on_create_called
  def on_create
    self.on_create_called = true
  end
end

describe "Callbacks" do
  before do
    @data_source = {
      sections: [
        {
          cells: [
            {
              on_create: proc {},
              on_display: proc {},
              on_end_display: proc {},
              on_select: proc {},
              on_deselect: proc {},
              accessoryType: UITableViewCellAccessoryDetailDisclosureButton,
              editingAccessoryType: UITableViewCellAccessoryDetailDisclosureButton,
              on_accessory_button_tap: proc {}
            },
            {
              on_create: :my_on_create_callback,
              on_display: :my_on_display_callback,
              on_end_display: :my_on_end_display_callback,
              on_select: :my_on_select_callback,
              on_deselect: :my_on_deselect_callback,
            }
          ]
        }
      ]
    }
    self.controller.data_source = @data_source
  end

  tests TableViewController

  it "should call on_create method" do
    cell = controller.tableView.cell_at_index([0,0])
    cell.on_create_called.should == true
  end

  it "should call on_create proc" do
    # Wait a bit so the cell rendered
    wait 0.5 do
      @data_source[:sections].first[:cells].first[:on_create].should.be.called
    end
  end

  it "should call on_create action method" do
    controller.mock!(:my_on_create_callback)
  end

  it "should call on_display method" do
    cell = controller.tableView.cell_at_index([0,0])
    cell.mock!(:on_display)
    controller.tableView.reloadData
  end

  it "should call on_display proc" do
    # Wait a bit so the cell rendered
    wait 0.5 do
      @data_source[:sections].first[:cells].first[:on_display].should.be.called
    end
  end

  it "should call on_display action method" do
    controller.mock!(:my_on_display_callback)
  end

  it "should call on_end_display method" do
    cell = controller.tableView.cell_at_index([0,0])
    cell.mock!(:on_end_display)
    controller.tableView.reloadSections(NSIndexSet.indexSetWithIndex(0), withRowAnimation:UITableViewRowAnimationNone)
    wait 0.5 do
      # need to wait a bit for cell reloading
    end
  end

  it "should call on_end_display proc" do
    controller.tableView.reloadSections(NSIndexSet.indexSetWithIndex(0), withRowAnimation:UITableViewRowAnimationNone)
    wait 0.5 do
      # need to wait a bit for cell reloading
      @data_source[:sections].first[:cells].first[:on_end_display].should.be.called
    end
  end

  it "should call on_end_display action method" do
    controller.mock!(:my_on_end_display_callback)
    controller.tableView.reloadSections(NSIndexSet.indexSetWithIndex(0), withRowAnimation:UITableViewRowAnimationNone)
  end

  it "should call on_select" do
    cell = controller.tableView.cell_at_index([0,0])
    cell.mock!(:on_select)
    tap(cell, at: :bottom)
  end

  it "should call on_select proc" do
    tap(controller.tableView.cell_at_index([0,0]), at: :bottom)
    @data_source[:sections].first[:cells].first[:on_select].should.be.called
  end

  it "should call on_select action method" do
    cell = controller.tableView.cell_at_index([0,1])
    controller.mock!(:my_on_select_callback)
    tap(cell, at: :bottom)
  end

  it "should call on_deselect" do
    cell = controller.tableView.cell_at_index([0,0])
    cell.mock!(:on_deselect)
    tap(controller.tableView.cell_at_index([0,0]), at: :bottom)
    tap(controller.tableView.cell_at_index([0,1]), at: :bottom)
  end

  it "should call on_deselect proc" do
    tap(controller.tableView.cell_at_index([0,0]), at: :bottom)
    tap(controller.tableView.cell_at_index([0,1]), at: :bottom)
    @data_source[:sections].first[:cells].first[:on_deselect].should.be.called
  end

  it "should call on_deselect action method" do
    controller.mock!(:my_on_deselect_callback)
    tap(controller.tableView.cell_at_index([0,1]), at: :bottom)
    tap(controller.tableView.cell_at_index([0,0]), at: :bottom)
  end

  it "should call on_accessory_button_tapped is normal mode" do
    cell = controller.tableView.cell_at_index([0,0])
    tap(cell, at: :right)
    @data_source[:sections].first[:cells].first[:on_accessory_button_tap].should.be.called
  end

  it "should call on_accessory_button_tapped in editing mode" do
    controller.tableView.editing = true
    cell = controller.tableView.cell_at_index([0,0])
    tap(cell, at: :right)
    @data_source[:sections].first[:cells].first[:on_accessory_button_tap].should.be.called
  end
end
