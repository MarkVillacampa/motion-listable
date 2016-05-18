describe "Headers and footers" do
  before do
    @data_source = {
      sections: [
        {
          header_view: UIView.new.tap do |view|
            view.frame = [[0,0],[0,50]]
            view.backgroundColor = UIColor.redColor
            view.accessibilityLabel = "header_view"
          end,
          header_height: 50,
          footer_view: UIView.new.tap do |view|
            view.frame = [[0,0],[0,50]]
            view.backgroundColor = UIColor.redColor
            view.accessibilityLabel = "footer_view"
          end,
          footer_height: 50,
          cells: [
            {
              textLabel: { text: "Hello World" },
            },
          ]
        },
        {
          header_title: "Section Title",
          footer_title: "Section Footer Title",
          cells: [
            {
              textLabel: { text: "Hello World" },
            },
          ]
        }
      ]
    }
    self.controller.data_source = @data_source
  end

  tests TableViewController

  it "can display a section header view" do
    view("header_view").should.not.be.nil
  end

  it "can display a section footer view" do
    view("footer_view").should.not.be.nil
  end

  it "can display a section header title" do
    view("Section Title").should.not.be.nil
  end

  it "can display a section footer title" do
    view("Section Footer Title").should.not.be.nil
  end
end
