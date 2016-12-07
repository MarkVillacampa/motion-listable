class MyTableViewCellSubclass < UITableViewCell
end

describe "Custom cells" do
  before do
    @cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: "default").tap do |c|
      c.textLabel.text = "Cached Cell"
    end
    @data_source = {
      sections: [
        {
          cells: [
            {
              textLabel: { text: "Hello World" },
              class: MyTableViewCellSubclass,
              type: UITableViewCellStyleValue1
            },
            {
              cell: @cell
            }
          ]
        }
      ]
    }
    self.controller.data_source = @data_source
  end

  tests TableViewController

  it "can display a cell and edit attributes" do
    view("Hello World").should.not.be.nil
  end

  it "can display a cell with custom class" do
    cell = controller.tableView.cell_at_index([0, 0])
    cell.class.should == MyTableViewCellSubclass
  end

  it "can display a cached UITableViewCell instance" do
    view("Cached Cell").should.not.be.nil
  end
end
