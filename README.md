# motion-listable

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'motion-listable'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install motion-listable

## Usage

TODO: Write usage instructions here

### Using the controller

### Creating the table

### Setting table properties

### Setting cell properties

### Using custom cell class

```ruby
  {
    class: MyTableViewCellSubclass,
    type: UITableViewTypeSubtitle
  }
```

### Cell lifecycle callbacks

```ruby
  {
    textLabel: { text: "Hello World" },
    on_display: proc {},
    on_end_display: proc {},
    on_select: proc {},
    on_deselect: proc {},
    accessoryType: UITableViewCellAccessoryDetailDisclosureButton,
    editingAccessoryType: UITableViewCellAccessoryDetailDisclosureButton,
    on_accessory_button_tap: proc {}
  },
  {
    on_display: :my_on_display_callback,
    on_end_display: :my_on_end_display_callback,
    on_select: :my_on_select_callback,
    on_deselect: :my_on_deselect_callback,
  },
```

### Using existing cell instances

```ruby
  my_instanciated_cell =
  {
    sections: [
      {
        cells: 
          {
            textLabel: { text: "My cell" },
          },
          my_instanciated_cell
        ]
      }
    ]
  }
```

### Reordering cells

  Cells inside a section will have reorder controls if the `:can_reorder` key is
  set to `true` for that section. Rows can only be moved within their section.

  on_row_move

### Editing controls

  - Insert button:

```ruby
  {
    editingStyle: UITableViewCellEditingStyleInsert,
    on_insert: proc {}
  }
```

IMAGE

  - Delete button:

```ruby
  {
    editingStyle: UITableViewCellEditingStyleDelete,
    on_delete: proc {}
  }
```

IMAGE

  - Custom editing buttons:

```ruby
  {
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
```

IMAGE

### Section headers and footers

```ruby
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
    title: "Section Title",
    footer_title: "Section Footer Title",
    cells: [
      {
        textLabel: { text: "Hello World" },
      },
    ]
  }
```

IMAGE
    
## FAQ

Why are some delegate and data source methods commented out?

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
