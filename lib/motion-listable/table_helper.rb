module MotionListable
  module TableHelper
    def data_source
      {}
    end

    def default_cell_style
      {}
    end

    def sections
      data_source[:sections] || []
    end

    def callback(tableView, indexPath, symbol, cell = nil, apply_attributes = true)
      cell ||= tableView.cellForRowAtIndexPath(indexPath)
      section = self.sections[indexPath.section]
      cell_data = section ? section[:cells][indexPath.row] : {}
      cell_data = default_cell_style.deep_merge(cell_data)
      apply_attributes(cell, cell_data) if apply_attributes
      action(tableView, indexPath, symbol, cell, cell_data)
    end
    private :callback

    def action(tableView, indexPath, symbol, cell = nil, cell_data = nil)
      cell ||= tableView.cellForRowAtIndexPath(indexPath)
      cell_data ||= begin
        data = self.sections[indexPath.section][:cells][indexPath.row]
        default_cell_style.deep_merge(data)
      end
      if cell.respond_to?(symbol)
        case cell.method(symbol).arity
        when -1, 3
          cell.send(symbol, cell_data, cell, indexPath)
        when 0
          cell.send(symbol)
        else
          raise ArgumentError, "method '#{symbol}' must accept either 3 arguments (cell_data, cell, indexPath) or no arguments."
        end
      end
      self.send(symbol, cell_data, cell, indexPath) if self.respond_to?(symbol)
      action = cell_data[symbol]
      return unless action
      if action.is_a?(Proc)
        case action.arity
        when -1, 3
          action.call(cell_data, cell, indexPath)
        when 0
          action.call
        else
          raise ArgumentError, "proc for index path [#{indexPath.section}, #{indexPath.row}] must accept either 3 arguments (cell_data, cell, indexPath) or no arguments."
        end
      elsif self.respond_to?(action)
        case self.method(action).arity
        when -1, 3
          self.send(action, cell_data, cell, indexPath)
        when 0
          self.send(action)
        else
          raise ArgumentError, "method '#{symbol}' must accept either 3 arguments (cell_data, cell, indexPath) or no arguments."
        end
      end
    end
    private :action

    def apply_attributes(receiver, attributes = {})
      attributes.each do |attribute, value|
        if value.is_a? Hash
          getter = attribute.to_s
          apply_attributes(receiver.send(getter), value) if receiver.respond_to?(getter)
        else
          ruby_setter = "#{attribute}="
          if receiver.respond_to?(ruby_setter)
            receiver.send(ruby_setter, value)
            next
          end
          attribute_str = attribute.to_s
          attribute_str[0] = attribute_str[0].upcase
          objc_setter = "set#{attribute_str}:"
          if receiver.respondsToSelector(objc_setter)
            receiver.send(objc_setter, value)
          end
        end
      end
    end
    private :apply_attributes

    ## UITableViewDelegate

    # Display customization

    def tableView(tableView, willDisplayCell:cell, forRowAtIndexPath:indexPath)
      callback(tableView, indexPath, :on_display, cell, true)
    end

    # def tableView(tableView, didEndDisplayingCell:cell, forRowAtIndexPath:indexPath)
    #   callback(tableView, indexPath, :on_end_display, cell, true)
    # end

    # TODO: Implement footer/header display callbacks if someone requests it
    # def tableView(tableView, willDisplayHeaderView:view, forSection:section)
    # end

    # def tableView(tableView, willDisplayFooterView:view, forSection:section)
    # end

    # def tableView(tableView, didEndDisplayingHeaderView:view, forSection:section)
    # end

    # def tableView(tableView, didEndDisplayingFooterView:view, forSection:section)
    # end

    # Variable height support

    def tableView(tableView, heightForRowAtIndexPath:indexPath)
      sections[indexPath.section][:cells][indexPath.row][:height] || default_cell_style[:height] || UITableViewAutomaticDimension
    end

    def tableView(tableView, heightForHeaderInSection:section)
      sections[section][:header_height] || UITableViewAutomaticDimension
    end

    def tableView(tableView, heightForFooterInSection:section)
      sections[section][:footer_height] || UITableViewAutomaticDimension
    end

    # These methods allow for fast load times of the table by providing an estimame height.
    # The methods above will be called later when the views are displayed, so more expensive logic should be place there.
    # def tableView(tableView, estimatedHeightForRowAtIndexPath:indexPath)
    # end

    # def tableView(tableView, estimatedHeightForHeaderInSection:section)
    # end

    # def tableView(tableView, estimatedHeightForFooterInSection:section)
    # end

    # Section header & footer information
    # If you implement both the title and view methods, the views take precedence.

    def tableView(tableView, viewForHeaderInSection:section)
      sections[section][:header_view] if sections[section][:header_view]
    end

    def tableView(tableView, viewForFooterInSection:section)
      sections[section][:footer_view] if sections[section][:footer_view]
    end

    # Accessories (disclosures)

    # Not called when the cell has a custom accessoryView set
    def tableView(tableView, accessoryButtonTappedForRowWithIndexPath:indexPath)
      callback(tableView, indexPath, :on_accessory_button_tap)
    end

    # Selection

    # Returning false stops the selection process and does not change the status of the currently selected cell.
    # def tableView(tableView, shouldHighlightRowAtIndexPath:indexPath)
    # end

    def tableView(tableView, didHighlightRowAtIndexPath:indexPath)
      callback(tableView, indexPath, :on_highlight)
    end

    def tableView(tableView, didUnhighlightRowAtIndexPath:indexPath)
      callback(tableView, indexPath, :on_unhighlight)
    end

    # If nil is returned, the cell is not selected.
    # If a different index path is returned, the cell at that index path is selected instead.
    # def tableView(tableView, willSelectRowAtIndexPath:indexPath)
    # end

    # def tableView(tableView, willDeselectRowAtIndexPath:indexPath)
    # end

    def tableView(tableView, didSelectRowAtIndexPath:indexPath)
      callback(tableView, indexPath, :on_select)
    end

    def tableView(tableView, didDeselectRowAtIndexPath:indexPath)
      callback(tableView, indexPath, :on_deselect)
    end

    # Editing

    # Allows overriding the editingStyle of a cell at a particular indexPath
    def tableView(tableView, editingStyleForRowAtIndexPath:indexPath)
      cell_data = self.sections[indexPath.section][:cells][indexPath.row]
      return cell_data[:cell].editingStyle if cell_data[:cell]
      cell_data = default_cell_style.deep_merge(cell_data)
      cell_data[:editingStyle] || UITableViewCellEditingStyleNone
    end

    # Called for cells with editingStyle = UITableViewCellEditingStyleDelete
    # def tableView(tableView, titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath)
    # end

    # iOS 8.0 and up
    # If implemented, will be used instead of the method above
    # Called for cells with editingStyle = UITableViewCellEditingStyleDelete
    def tableView(tableView, editActionsForRowAtIndexPath:indexPath)
      cell_data = self.sections[indexPath.section][:cells][indexPath.row]
      cell_data = default_cell_style.deep_merge(cell_data)
      cell_data[:edit_actions]
    end

    # By default, rows are indented while the table is in editing mode.
    # Return false to change that or a particular row.
    # This method only applies to grouped style table views.
    def tableView(tableView, shouldIndentWhileEditingRowAtIndexPath:indexPath)
      false
    end

    # Called when the 'editing' property of a table changes automatically because the user has swiped on a table, showing the insert/delete/move controls.
    # def tableView(tableView, willBeginEditingRowAtIndexPath:indexPath)
    # end

    # def tableView(tableView, didEndEditingRowAtIndexPath:indexPath)
    # end

    # Moving/reordering

    # Allows customization of the target row for a particular row as it is being moved/reordered
    def tableView(tableView, targetIndexPathForMoveFromRowAtIndexPath:sourceIndexPath, toProposedIndexPath:proposedDestinationIndexPath)
      source_section = sourceIndexPath.section
      proposed_section = proposedDestinationIndexPath.section

      cells = self.sections[sourceIndexPath.section][:cells]
      first_movable_cell = cells.index(cells.detect { |c| c[:can_reorder] != false })
      last_movable_cell = (cells.count - 1) - cells.reverse.index(cells.reverse.detect { |c| c[:can_reorder] != false })

      # We only allow moving rows in the same section
      if source_section == proposed_section
        if proposedDestinationIndexPath.row > last_movable_cell
          NSIndexPath.indexPathForRow(last_movable_cell, inSection:source_section)
        elsif proposedDestinationIndexPath.row < first_movable_cell
          NSIndexPath.indexPathForRow(first_movable_cell, inSection:source_section)
        else
          proposedDestinationIndexPath
        end
      elsif source_section > proposed_section
        NSIndexPath.indexPathForRow(first_movable_cell, inSection:source_section)
      else # source_section < proposed_section
        NSIndexPath.indexPathForRow(last_movable_cell, inSection:source_section)
      end
    end

    # Indentation

    # def tableView(tableView, indentationLevelForRowAtIndexPath:indexPath)
    # end

    # Copy/Paste. All three methods must be implemented.

    # def tableView(tableView, shouldShowMenuForRowAtIndexPath:indexPath)
    # end

    # def tableView(tableView, canPerformAction:action, forRowAtIndexPath:indexPath, withSender:sender)
    # end

    # def tableView(tableView, performAction:action, forRowAtIndexPath:indexPath, withSender:sender)
    # end

    ## UITableViewDataSource

    def tableView(tableView, numberOfRowsInSection:section)
      (sections[section][:cells] || []).count
    end

    def tableView(tableView, cellForRowAtIndexPath:indexPath)
      cell_data = self.sections[indexPath.section][:cells][indexPath.row]
      return cell_data[:cell] if cell_data[:cell]
      cell_data = default_cell_style.deep_merge(cell_data)

      reuse_id = cell_data[:id] || "default"
      cell = tableView.dequeueReusableCellWithIdentifier(reuse_id)

      if cell.nil?
        cell_type = cell_data[:type] || UITableViewCellStyleDefault
        klass = cell_data[:class] || UITableViewCell
        cell = klass.alloc.initWithStyle(cell_type, reuseIdentifier:reuse_id)
        apply_attributes(cell, cell_data)
        action(tableView, indexPath, :on_create, cell, cell_data)
      end

      cell
    end

    def numberOfSectionsInTableView(tableView)
      sections.count
    end

    def tableView(tableView, titleForHeaderInSection:section)
      sections[section][:header_title] if sections[section][:header_title]
    end

    def tableView(tableView, titleForFooterInSection:section)
      sections[section][:footer_title] if sections[section][:footer_title]
    end

    # Editing

    # Used to expclude some rows from having edit controls, by returning false for that row.
    # Since we set UITableViewCellEditingStyleNone as the default editingStyle, we can safely return true for all rows.
    def tableView(tableView, canEditRowAtIndexPath:indexPath)
      true
    end

    # Moving/reordering

    # Returning false for a particular cell, will make the cell not have a reordering control
    def tableView(tableView, canMoveRowAtIndexPath:indexPath)
      section_data = self.sections[indexPath.section]
      cell_data = section_data[:cells][indexPath.row]
      return false if cell_data[:can_reorder] == false
      section_data[:can_reorder]
    end

    # Called when a row moves its position because the user dragged the reorder control
    def tableView(tableView, moveRowAtIndexPath:sourceIndexPath, toIndexPath:destinationIndexPath)
      section_data = self.sections[sourceIndexPath.section]
      return unless section_data[:on_row_move]
      section_data[:on_row_move].call(sourceIndexPath, destinationIndexPath)
    end

    # Index

    # Returns an array of strings to be show in the index list view on the right of the table.
    # Only works for plain style tables.
    # def sectionIndexTitlesForTableView(tableView)
    # end

    # Given the a section title, it's index in the array returned by the previous method, returns an integer representing the section that title represents.
    # def tableView(tableView, sectionForSectionIndexTitle:title, atIndex:index)
    # end

    # Data manipulation - insert and delete support

    # Called when the user taps the delete (minus) or insert (plus) buttons in editing mode.
    # This has no effect when using UITableViewRowAction, where it's handler will be invoked instead.
    # EditingStyle can be UITableViewCellEditingStyleDelete or UITableViewCellEditingStyleInsert
    # Implementing this method also enables swipe-to-delete feature
    def tableView(tableView, commitEditingStyle:editingStyle, forRowAtIndexPath:indexPath)
      case editingStyle
      when UITableViewCellEditingStyleDelete
        action(tableView, indexPath, :on_delete)
      when UITableViewCellEditingStyleInsert
        action(tableView, indexPath, :on_insert)
      end
    end
  end
end
