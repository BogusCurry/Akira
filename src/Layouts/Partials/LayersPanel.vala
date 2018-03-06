/*
* Copyright (c) 2018 Alecaddd (http://alecaddd.com)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Alessandro "Alecaddd" Castellani <castellani.ale@gmail.com>
*/
public class Akira.Layouts.Partials.LayersPanel : Gtk.ListBox {
	public weak Akira.Window window { get; construct; }

	private const Gtk.TargetEntry targetEntries[] = {
		{ "ARTBOARD", Gtk.TargetFlags.SAME_APP, 0 }
	};

	public LayersPanel (Akira.Window main_window) {
		Object (
			window: main_window,
			activate_on_single_click: false,
			selection_mode: Gtk.SelectionMode.NONE
		);
	}

	construct {
		expand = true;
		get_style_context ().add_class ("sidebar-r");

		var artboard = new Akira.Layouts.Partials.Artboard (window, "Artboard 1");
		var artboard_area = new Gtk.Grid ();
		artboard_area.get_style_context ().add_class ("artboard-container");
		artboard_area.attach (new Gtk.Label ("Layer 1"), 0, 0, 1, 1);
		artboard_area.attach (new Gtk.Label ("Layer 2"), 0, 1, 1, 1);
		artboard_area.attach (new Gtk.Label ("Layer 3"), 0, 2, 1, 1);
		artboard_area.attach (new Gtk.Label ("Layer 4"), 0, 3, 1, 1);

		artboard.expander.add (artboard_area);

		var artboard2 = new Akira.Layouts.Partials.Artboard (window, "Artboard 2");
		var artboard3 = new Akira.Layouts.Partials.Artboard (window, "Artboard 3");

		insert (artboard, 0);
		insert (artboard2, 1);
		insert (artboard3, 2);

		row_activated.connect(on_row_activated);
		build_drag_and_drop ();
	}

	private void on_row_activated (Gtk.ListBoxRow row) {
		warning ("actvated");
	}

	private void build_drag_and_drop () {
		Gtk.drag_dest_set(this, Gtk.DestDefaults.ALL, targetEntries, Gdk.DragAction.MOVE);

		drag_data_received.connect(on_drag_data_received);
		// Gtk.drag_dest_set (scroll_area, Gtk.DestDefaults.ALL, target_list, Gdk.DragAction.MOVE);

		// scroll_area.drag_motion.connect(on_drag_motion);
		// scroll_area.drag_leave.connect(on_drag_leave);
		// scroll_area.drag_drop.connect(on_drag_drop);
		// scroll_area.drag_data_received.connect(on_drag_data_received);
	}

	private void on_drag_data_received (Gdk.DragContext context, int x, int y, Gtk.SelectionData selection_data, uint target_type, uint time) {
		Akira.Layouts.Partials.Artboard target;
		Gtk.Widget row;
		Akira.Layouts.Partials.Artboard source;
		int newPos;
		int oldPos;

		target  = (Akira.Layouts.Partials.Artboard) get_row_at_y (y);

		newPos = target.get_index();
		row = ((Gtk.Widget[]) selection_data.get_data ())[0];

		if (!(row is Akira.Layouts.Partials.Artboard)) {
			return;
		}

		source = (row as Akira.Layouts.Partials.Artboard);
		oldPos = source.get_index();

		if (source == target) {
			return;
		}

		remove (source);
		insert (source, newPos);
		// update_queue (oldPos, newPos);
		stdout.printf("New: %s - Old: %s\n", newPos.to_string (), oldPos.to_string ());
	}

	/* Emitted when a drag is over the destination */
	// private bool on_drag_motion (Gtk.Widget widget, Gdk.DragContext context, int x, int y, uint time)
	// {
	// 	// Fancy stuff here. This signal spams the console something horrible.
	// 	// print ("%s: on_drag_motion\n", widget.name);
	// 	return false;
	// }

	/* Emitted when a drag leaves the destination */
	// private void on_drag_leave (Gtk.Widget widget, Gdk.DragContext context, uint time) {
	// 	// print ("%s: on_drag_leave\n", widget.name);
	// }

	/*
	 * Emitted when the user releases (drops) the selection. It should check
	 * that the drop is over a valid part of the widget (if its a complex
	 * widget), and itself to return true if the operation should continue. Next
	 * choose the target type it wishes to ask the source for. Finally call
	 * Gtk.drag_get_data which will emit "drag_data_get" on the source.
	 */
	// private bool on_drag_drop (Gtk.Widget widget, Gdk.DragContext context, int x, int y, uint time) {
	// 	print ("%s: on_drag_drop\n", widget.name);

	// 	// Check to see if (x, y) is a valid drop site within widget
	// 	bool is_valid_drop_site = true;

	// 	// If the source offers a target
	// 	if (context.list_targets () != null) {
	// 		// Choose the best target type
	// 		var target_type = (Gdk.Atom) context.list_targets ().nth_data (Target.INT32);

	// 		// Request the data from the source.
	// 		Gtk.drag_get_data (
	// 				widget,         // will receive 'drag_data_received' signal
	// 				context,        // represents the current state of the DnD
	// 				target_type,    // the target type we want
	// 				time            // time stamp
	// 			);
	// 	} else {
	// 		// No target offered by source => error
	// 		is_valid_drop_site = false;
	// 	}

	// 	return is_valid_drop_site;
	// }

	/*
	 * Emitted when the data has been received from the source. It should check
	 * the SelectionData sent by the source, and do something with it. Finally
	 * it needs to finish the operation by calling Gtk.drag_finish, which will
	 * emit the "data_delete" signal if told to.
	 */
	// private void on_drag_data_received (Gtk.Widget widget, Gdk.DragContext context,
	// 									int x, int y,
	// 									Gtk.SelectionData selection_data,
	// 									uint target_type, uint time) {
	// 	if ((selection_data == null) || !(selection_data.get_length () >= 0)) {
	// 		return;
	// 	}

	// 	bool dnd_success = false;
	// 	bool delete_selection_data = false;

	// 	print ("%s: on_drag_data_received\n", widget.name);

	// 		if (context.get_suggested_action () == Gdk.DragAction.MOVE) {
	// 			delete_selection_data = true;
	// 		}

	// 		// Check that we got the format we can use
	// 		print (" Receiving ");
	// 		switch (target_type) {
	// 		case Target.INT32:
	// 			long* data = (long*) selection_data.get_data();
	// 			print ("integer: %ld", (*data));
	// 			dnd_success = true;
	// 			break;
	// 		case Target.STRING:
	// 			print ("string: %s", (string) selection_data.get_data());
	// 			dnd_success = true;
	// 			break;
	// 		default:
	// 			print ("nothing good");
	// 			break;
	// 		}

	// 		print (".\n");

	// 	if (dnd_success == false) {
	// 		print ("DnD data transfer failed!\n");
	// 	}

	// 	Gtk.drag_finish (context, dnd_success, delete_selection_data, time);
	// }
}