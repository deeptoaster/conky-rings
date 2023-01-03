config = {
  bg_color = 0xffffff,
  bg_alpha = 0.2,
  fg_color = 0xffffff,
  fg_alpha = 0.6,
  network_ethernet = 'eno1',
  network_wlan = 'wlo1'
}
elements = {
  {
    x0 = 0,
    y0 = 79,
    x1 = 337,
    y1 = 79,
    width = 2
  },
  {
    name = 'cpu',
    arg = '',
    max = 100,
    x = 400,
    y = 80,
    r = 60,
    width = 6,
    start_angle = -90,
    end_angle = 180
  },
  {
    name = 'acpitemp',
    arg = '',
    max = 100,
    x = 400,
    y = 80,
    r = 52,
    width = 6,
    start_angle = -90,
    end_angle = 180
  },
  {
    x0 = 0,
    y0 = 239,
    x1 = 337,
    y1 = 239,
    width = 2
  },
  {
    name = 'memperc',
    arg = '',
    max = 100,
    x = 400,
    y = 240,
    r = 60,
    width = 6,
    start_angle = -90,
    end_angle = 180
  },
  {
    name = 'swapperc',
    arg = '',
    max = 100,
    x = 400,
    y = 240,
    r = 52,
    width = 6,
    start_angle = -90,
    end_angle = 180
  },
  {
    x0 = 0,
    y0 = 399,
    x1 = 337,
    y1 = 399,
    width = 2
  },
  {
    name = 'execi',
    arg = "1 df --output=pcent -x tmpfs | sed -En '2s/\\s*(\\S+)%/\\1/p'",
    max = 100,
    x = 400,
    y = 400,
    r = 60,
    width = 6,
    start_angle = -90,
    end_angle = 180
  },
  {
    name = 'execi',
    arg = "1 df --output=pcent -x tmpfs | sed -En '3s/\\s*(\\S+)%/\\1/p'",
    max = 100,
    x = 400,
    y = 400,
    r = 52,
    width = 6,
    start_angle = -90,
    end_angle = 180
  },
  {
    name = 'execi',
    arg = "1 df --output=pcent -x tmpfs | sed -En '4s/\\s*(\\S+)%/\\1/p'",
    max = 100,
    x = 400,
    y = 400,
    r = 44,
    width = 6,
    start_angle = -90,
    end_angle = 180
  },
  {
    name = 'execi',
    arg = "1 df --output=pcent -x tmpfs | sed -En '5s/\\s*(\\S+)%/\\1/p'",
    max = 100,
    x = 400,
    y = 400,
    r = 36,
    width = 6,
    start_angle = -90,
    end_angle = 180
  },
  {
    x0 = 0,
    y0 = 559,
    x1 = 337,
    y1 = 559,
    width = 2
  },
  {
    name = 'downspeedf',
    arg = config['network_ethernet'],
    max = 12,
    log = true,
    x = 400,
    y = 560,
    r = 60,
    width = 6,
    start_angle = -90,
    end_angle = 180
  },
  {
    name = 'downspeedf',
    arg = config['network_wlan'],
    max = 12,
    log = true,
    x = 400,
    y = 560,
    r = 52,
    width = 6,
    start_angle = -90,
    end_angle = 180
  },
  {
    name = 'upspeedf',
    arg = config['network_ethernet'],
    max = 12,
    log = true,
    x = 400,
    y = 560,
    r = 44,
    width = 6,
    start_angle = -90,
    end_angle = 180
  },
  {
    name = 'upspeedf',
    arg = config['network_wlan'],
    max = 12,
    log = true,
    x = 400,
    y = 560,
    r = 36,
    width = 6,
    start_angle = -90,
    end_angle = 180
  }
}
require 'cairo'
function rgba(color, alpha)
  return color / 0x10000 % 0x100 / 255., color / 0x100 % 0x100 / 255.,
      color % 0x100 / 255., alpha
end
function draw_line(cr, pt)
  cairo_move_to(cr, pt['x0'], pt['y0'])
  cairo_line_to(cr, pt['x1'], pt['y1'])
  cairo_set_source_rgba(cr, rgba(config['fg_color'], config['fg_alpha']))
  cairo_set_line_width(cr, pt['width'])
  cairo_stroke(cr)
end
function draw_ring(cr, val, pt)
  local angle_0 = pt['start_angle'] * math.pi / 180 - math.pi / 2
  local angle_f = pt['end_angle'] * math.pi / 180 - math.pi / 2
  local angle_t = angle_0 + val / pt['max'] * (angle_f - angle_0)
  cairo_arc(cr, pt['x'], pt['y'], pt['r'], angle_0, angle_f)
  cairo_set_source_rgba(cr, rgba(config['bg_color'], config['bg_alpha']))
  cairo_set_line_width(cr, pt['width'])
  cairo_stroke(cr)
  cairo_arc(cr, pt['x'], pt['y'], pt['r'], angle_0, angle_t)
  cairo_set_source_rgba(cr, rgba(config['fg_color'], config['fg_alpha']))
  cairo_stroke(cr)
end
function setup_rings(cr, pt)
  if pt['name'] == nil then
    draw_line(cr, pt)
  else
    local val = conky_parse(
      string.format('${%s %s}', pt['name'], pt['arg'])
    ):gsub('%%', '')
    val = tonumber(val)
    if val == nil then
      return
    end
    if pt['log'] then
      val = math.log(val + 1)
    end
    draw_ring(cr, val, pt)
  end
end
function conky_rings()
  if conky_window == nil then
    return
  end
  local cs = cairo_xlib_surface_create(
    conky_window.display,
    conky_window.drawable,
    conky_window.visual,
    conky_window.width,
    conky_window.height
  )
  local cr = cairo_create(cs)
  for i in pairs(elements) do
    setup_rings(cr, elements[i])
  end
end
