-- hddbars by karabaja4
-- karabaja4@archlinux.us

require 'cairo'

-- colors
bar_colour_bg = 0xffffff
bar_colour_fg = 0xffffff

-- alpha
bar_alpha_bg = 0.15
bar_alpha_fg = 0.3

-- bar size
bar_length = 275
bar_height = 6

function rgb_to_r_g_b(colour, alpha)
	return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

cs, cr = nil
function draw_bar(x, y, percentage)

	-- check that conky has been running for at least 5s
	if conky_window==nil then return end
	
	-- declarations
	if cs == nil or cairo_xlib_surface_get_width(cs) ~= conky_window.width or cairo_xlib_surface_get_height(cs) ~= conky_window.height then
        if cs then cairo_surface_destroy(cs) end
        cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
    end
    if cr then cairo_destroy(cr) end
    cr = cairo_create(cs)
	
	-- background
	cairo_rectangle(cr, x, y, bar_length, bar_height);
	cairo_set_source_rgba(cr, rgb_to_r_g_b(bar_colour_bg, bar_alpha_bg));
	cairo_fill(cr);
	
	-- foreground
	cairo_rectangle(cr, x, y, bar_length*(percentage/100), bar_height);
	cairo_set_source_rgba(cr, rgb_to_r_g_b(bar_colour_fg, bar_alpha_fg));
	cairo_fill(cr);
	
	-- cleanup
	cairo_destroy(cr)
    cr = nil
    
end

function conky_hdd_bar()

	local perc1 = conky_parse('${fs_used_perc /}');
	local perc2 = conky_parse('${fs_used_perc /home}');
	local perc3 = conky_parse('${fs_used_perc /media/ST3250410AS}');
	local perc4 = conky_parse('${fs_used_perc /media/ST3160811AS}');
	local perc5 = conky_parse('${fs_used_perc /media/WD6400AAKS}');
	local perc6 = conky_parse('${fs_used_perc /media/VERBATIM}');
	
	local io_read1 = conky_parse('${diskio_read /dev/sda2}');
	local io_write1 = conky_parse('${diskio_write /dev/sda2}');
	
	-- draw_bar(45, 19, perc2);
	-- draw_bar(45, 26, ((io_read1 / 100000000) * 100))
	-- draw_bar(45, 33, ((io_write1 / 100000000) * 100))
	
end
