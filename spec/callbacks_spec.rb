CALLBACKS = %w(on_create on_display on_end_display on_select on_deselect
               on_accessory_button_tap on_delete on_insert)

class UITableViewCell
  CALLBACKS.each do |method|
    attr_accessor "#{method}_called"
    self.send(:define_method, method) do |cell_data, cell, indexPath|
      self.instance_variable_set("@#{method}_called", true)
    end
  end
end

describe "Callbacks" do
  before do
    highlight_touches!
    @data_source = {
      sections: [
        {
          cells: [
            {
              backgroundColor: UIColor.greenColor,
              textLabel: { text: "1" },
              on_create: proc {},
              on_display: proc {},
              on_end_display: proc {},
              on_select: proc {},
              on_deselect: proc {},
              on_accessory_button_tap: proc {},
              accessoryType: UITableViewCellAccessoryDetailDisclosureButton,
              editingAccessoryType: UITableViewCellAccessoryDetailDisclosureButton
            },
            {
              backgroundColor: UIColor.greenColor,
              textLabel: { text: "2" },
              on_create: :my_on_create_callback,
              on_display: :my_on_display_callback,
              on_end_display: :my_on_end_display_callback,
              on_select: :my_on_select_callback,
              on_deselect: :my_on_deselect_callback,
              on_accessory_button_tap: :my_on_accessory_button_tap_callback,
              accessoryType: UITableViewCellAccessoryDetailDisclosureButton,
              editingAccessoryType: UITableViewCellAccessoryDetailDisclosureButton
            }
          ]
        }
      ]
    }
    self.controller.data_source = @data_source
    self.controller.tableView.reloadData
  end

  tests TableViewController

  it "on_create - should call the cell method" do
    cell = controller.tableView.cell_at_index([0, 0])
    cell.on_create_called.should == true
  end

  it "on_create - should call the proc" do
    # Wait a bit so the cell is rendered
    wait 0.1 do
      @data_source[:sections].first[:cells].first[:on_create].should.be.called
    end
  end

  it "on_create - should call the controller action method" do
    controller.mock!(:my_on_create_callback) { |cell_data, cell, indexPath| }
  end

  it "on_create - should call controller default method" do
    controller.mock!(:on_create) { |cell_data, cell, indexPath| }
  end

  it "on_display - should call the cell method" do
    cell = controller.tableView.cell_at_index([0, 0])
    cell.on_display_called.should == true
  end

  it "on_display - should call the proc" do
    # Wait a bit so the cell is rendered
    wait 0.1 do
      @data_source[:sections].first[:cells].first[:on_display].should.be.called
    end
  end

  it "on_display - should call the controller action method" do
    controller.mock!(:my_on_display_callback) { |cell_data, cell, indexPath| }
  end

  it "on_display - should call the controller default method" do
    controller.mock!(:on_display) { |cell_data, cell, indexPath| }
  end

  it "on_end_display - should call the cell method" do
    cell = controller.tableView.cell_at_index([0, 0])
    @data_source[:sections].clear
    controller.tableView.deleteSections(NSIndexSet.indexSetWithIndex(0), withRowAnimation:UITableViewRowAnimationNone)
    wait 0.5 do
      cell.on_end_display_called.should == true
      # need to wait a bit for cell reloading
    end
  end

  # it "should call the proc" do
  #   cell = controller.tableView.cell_at_index([0, 0])
  #   block = @data_source[:sections].first[:cells].first[:on_end_display]
  #   @data_source[:sections].clear
  #   controller.tableView.deleteSections(NSIndexSet.indexSetWithIndex(0), withRowAnimation:UITableViewRowAnimationNone)
  #   wait 0.5 do
  #     block.should.be.called
  #   end
  # end

  # it "should call the controller action method" do
  #   cell = controller.tableView.cell_at_index([0, 0])
  #   controller.mock!(:my_on_end_display_callback) { |cell_data, cell, indexPath| }
  #   @data_source[:sections].clear
  #   controller.tableView.deleteSections(NSIndexSet.indexSetWithIndex(0), withRowAnimation:UITableViewRowAnimationNone)
  #   wait 0.5 do
  #     # need to wait a bit for cell reloading
  #   end
  # end

  it "on_end_display - should call the controller default method" do
    # make sure the cell is displayed
    controller.tableView.cell_at_index([0, 0])
    controller.mock!(:on_end_display) { |cell_data, cell, indexPath| }
    @data_source[:sections].clear
    controller.tableView.deleteSections(NSIndexSet.indexSetWithIndex(0), withRowAnimation:UITableViewRowAnimationNone)
    wait 0.5 do
      # need to wait a bit for cell reloading
    end
  end

  it "on_select - should call the cell method" do
    cell = controller.tableView.cell_at_index([0, 0])
    cell.mock!(:on_select) { |cell_data, cell, indexPath| }
    tap(cell, at: :bottom)
  end

  it "on_select - should call the proc" do
    tap(controller.tableView.cell_at_index([0, 0]), at: :bottom)
    @data_source[:sections].first[:cells].first[:on_select].should.be.called
  end

  it "on_select - should call the controller action method" do
    cell = controller.tableView.cell_at_index([0, 1])
    controller.mock!(:my_on_select_callback) { |cell_data, cell, indexPath| }
    tap(cell, at: :bottom)
  end

  it "on_select - should call the controller default method" do
    cell = controller.tableView.cell_at_index([0, 1])
    controller.mock!(:my_on_select_callback) { |cell_data, cell, indexPath| }
    tap(cell, at: :bottom)
  end

  it "on_deselect - should call the cell method" do
    cell = controller.tableView.cell_at_index([0, 0])
    cell.mock!(:on_deselect) { |cell_data, cell, indexPath| }
    tap(controller.tableView.cell_at_index([0, 0]), at: :bottom)
    tap(controller.tableView.cell_at_index([0, 1]), at: :bottom)
  end

  it "on_deselect - should call the proc" do
    tap(controller.tableView.cell_at_index([0, 0]), at: :bottom)
    tap(controller.tableView.cell_at_index([0, 1]), at: :bottom)
    @data_source[:sections].first[:cells].first[:on_deselect].should.be.called
  end

  it "on_deselect - should call the controller action method" do
    controller.mock!(:my_on_deselect_callback) { |cell_data, cell, indexPath| }
    tap(controller.tableView.cell_at_index([0, 1]), at: :bottom)
    tap(controller.tableView.cell_at_index([0, 0]), at: :bottom)
  end

  it "on_deselect - should call the controller default method" do
    controller.mock!(:on_deselect) { |cell_data, cell, indexPath| }
    tap(controller.tableView.cell_at_index([0, 1]), at: :bottom)
    tap(controller.tableView.cell_at_index([0, 0]), at: :bottom)
  end

  it "on_accessory_button_tap - should call the cell method in normal mode" do
    cell = controller.tableView.cell_at_index([0, 0])
    frame = cell.frame
    tap(cell, at: CGPointMake(CGRectGetMaxX(frame) - 40, CGRectGetMidY(frame)))
    wait 0.1 do
      cell.on_accessory_button_tap_called.should == true
    end
  end

  it "on_accessory_button_tap - should call the cell method in editing mode" do
    controller.tableView.editing = true
    cell = controller.tableView.cell_at_index([0, 0])
    frame = cell.frame
    tap(cell, at: CGPointMake(CGRectGetMaxX(frame) - 40, CGRectGetMidY(frame)))
    wait 0.1 do
      cell.on_accessory_button_tap_called.should == true
    end
  end

  it "on_accessory_button_tap - should call the proc in normal mode" do
    cell = controller.tableView.cell_at_index([0, 0])
    frame = cell.frame
    tap(cell, at: CGPointMake(CGRectGetMaxX(frame) - 40, CGRectGetMidY(frame)))
    wait 0.1 do
      @data_source[:sections].first[:cells].first[:on_accessory_button_tap].should.be.called
    end
  end

  it "on_accessory_button_tap - should call the proc method in editing mode" do
    controller.tableView.editing = true
    cell = controller.tableView.cell_at_index([0, 0])
    frame = cell.frame
    tap(cell, at: CGPointMake(CGRectGetMaxX(frame) - 40, CGRectGetMidY(frame)))
    wait 0.1 do
      @data_source[:sections].first[:cells].first[:on_accessory_button_tap].should.be.called
    end
  end

  it "on_accessory_button_tap - should call the controller action method in normal mode" do
    controller.mock!(:my_on_accessory_button_tap_callback) { |cell_data, cell, indexPath| }
    cell = controller.tableView.cell_at_index([0, 1])
    frame = cell.frame
    tap(cell, at: CGPointMake(CGRectGetMaxX(frame) - 40, CGRectGetMidY(frame)))
    wait 0.1 do
    end
  end

  it "on_accessory_button_tap - should call the controller action method in editing mode" do
    controller.tableView.editing = true
    controller.mock!(:my_on_accessory_button_tap_callback) { |cell_data, cell, indexPath| }
    cell = controller.tableView.cell_at_index([0, 1])
    frame = cell.frame
    tap(cell, at: CGPointMake(CGRectGetMaxX(frame) - 40, CGRectGetMidY(frame)))
    wait 0.1 do
      # need to wait a bit for cell reloading
    end
  end

  it "on_accessory_button_tap - should call the controller default method in normal mode" do
    controller.mock!(:on_accessory_button_tap) { |cell_data, cell, indexPath| }
    cell = controller.tableView.cell_at_index([0, 0])
    frame = cell.frame
    tap(cell, at: CGPointMake(CGRectGetMaxX(frame) - 40, CGRectGetMidY(frame)))
    wait 0.1 do
      # need to wait a bit for cell reloading
    end
  end

  it "on_accessory_button_tap - should call the controller default method in editing mode" do
    controller.tableView.editing = true
    controller.mock!(:on_accessory_button_tap) { |cell_data, cell, indexPath| }
    cell = controller.tableView.cell_at_index([0, 0])
    frame = cell.frame
    tap(cell, at: CGPointMake(CGRectGetMaxX(frame) - 40, CGRectGetMidY(frame)))
    wait 0.1 do
      # need to wait a bit for cell reloading
    end
  end
end
