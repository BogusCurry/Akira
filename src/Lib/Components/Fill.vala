/**
 * Copyright (c) 2019-2021 Alecaddd (https://alecaddd.com)
 *
 * This file is part of Akira.
 *
 * Akira is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.

 * Akira is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License
 * along with Akira. If not, see <https://www.gnu.org/licenses/>.
 *
 * Authored by: Alessandro "Alecaddd" Castellani <castellani.ale@gmail.com>
 */

/**
 * Fill component to keep track of a single filling, which includes different attributes.
 */
public class Akira.Lib.Components.Fill : Component {
    public unowned Fills fills { get; set; }
    // Since items can have multiple filling colors, we need to keep track of each
    // with a unique identifier in order to properly update them.
    public int id { get; set; }

    public Gdk.RGBA color { get; set; }

    // Store the hexadecimal string version of the color (E.g.: #FF00CC)
    public string hex { get; set; }
    public int alpha { get; set; }
    public bool hidden { get; set; }

    public Fill (Fills _fills, Items.CanvasItem _item, Gdk.RGBA init_color, int fill_id) {
        fills = _fills;
        item = _item;
        id = fill_id;
        color = init_color;
        alpha = 255;

        set_fill ();
    }

    /**
     * Apply the properly converted fill color to the item.
     */
    private void set_fill () {
        // Make the item transparent if the color is set to hidden.
        if (hidden) {
            if (item is Items.CanvasArtboard) {
                ((Items.CanvasArtboard) item).background.set ("fill-color-rgba", null);
            } else {
                item.set ("fill-color-rgba", null);
            }
            hex = "";
            return;
        }

        // Store the color in a new RGBA variable so we can manipulate it.
        var rgba_fill = Gdk.RGBA ();
        rgba_fill = color;

        // Keep in consideration the global opacity to properly update the fill color.
        rgba_fill.alpha = ((double) alpha) / 255 * item.opacity.opacity / 100;
        hex = Utils.Color.rgba_to_hex (rgba_fill.to_string ());
        uint fill_color_rgba = Utils.Color.rgba_to_uint (rgba_fill);

        // Temporarily set the item color here. This will be moved to the Fills component
        // once we enable multiple fillings.
        if (item is Items.CanvasArtboard) {
            ((Items.CanvasArtboard) item).background.set ("fill-color-rgba", fill_color_rgba);
        } else {
            item.set ("fill-color-rgba", fill_color_rgba);
        }
    }

    /**
     * Helper method used by the Fills component to force a reset of of the applied colors.
     * This will most likely be removed once we start supporting multiple fillings.
     */
    public void reload () {
        set_fill ();
    }

    /**
     * Get the new hexadecimal string defined by the user and update the fill color.
     */
    public void set_fill_hex (string new_hex) {
        // Interrupt if the value didn't change.
        if (new_hex == hex) {
            return;
        }

        hex = new_hex;
        color.parse (hex);

        set_fill ();
    }

    public void remove () {
        fills.remove_fill (this);
    }
}
