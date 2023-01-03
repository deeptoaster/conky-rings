config = {
  bg_color = 0xffffff,
  bg_alpha = 0.2,
  fg_color = 0xffffff,
  fg_alpha = 0.6,
  network_ethernet = 'eno1',
  network_wlan = 'wlo1'
}
groups = {
  {
    {
      breakpoints = { 'top cpu 1', 'top cpu 2', 'top cpu 3', 'top cpu 4' },
      command = 'cpu',
      max = 100
    },
    { command = 'acpitemp', max = 100 }
  },
  {
    {
      breakpoints = {
        'top_mem mem 1',
        'top_mem mem 2',
        'top_mem mem 3',
        'top_mem mem 4'
      },
      command = 'memperc',
      max = 100
    },
    { command = 'swapperc', max = 100 }
  },
  {
    {
      command =
          "execi 1 df --output=pcent -x tmpfs | sed -En '2s/\\s*(\\S+)%/\\1/p'",
      max = 100
    },
    {
      command =
          "execi 1 df --output=pcent -x tmpfs | sed -En '3s/\\s*(\\S+)%/\\1/p'",
      max = 100
    },
    {
      command =
          "execi 1 df --output=pcent -x tmpfs | sed -En '4s/\\s*(\\S+)%/\\1/p'",
      max = 100
    },
    {
      command =
          "execi 1 df --output=pcent -x tmpfs | sed -En '5s/\\s*(\\S+)%/\\1/p'",
      max = 100
    },
    {
      command =
          "execi 1 df --output=pcent -x tmpfs | sed -En '6s/\\s*(\\S+)%/\\1/p'",
      max = 100
    }
  },
  {
    {
      command = 'downspeedf ' .. config['network_ethernet'],
      log = true,
      max = 12
    },
    {
      command = 'downspeedf ' .. config['network_wlan'],
      log = true,
      max = 12
    },
    {
      command = 'upspeedf ' .. config['network_ethernet'],
      log = true,
      max = 12
    },
    { command = 'upspeedf ' .. config['network_wlan'], log = true, max = 12 }
  }
}
require 'cairo'
function angle(position, max)
  return position / max * math.pi * 1.5 - math.pi
end
function evaluate(command, log)
  local value = conky_parse(string.format('${%s}', command)):gsub('%%', '')
  value = tonumber(value)
  if value == nil then
    return
  elseif log then
    return math.log(value + 1)
  else
    return value
  end
end
function rgba(color, alpha)
  return color / 0x10000 % 0x100 / 255, color / 0x100 % 0x100 / 255,
      color % 0x100 / 255, alpha
end
function draw_line(cairo, y, breakpoint_count)
  cairo_set_line_width(cairo, 2)
  cairo_set_source_rgba(cairo, rgba(config['fg_color'], config['fg_alpha']))
  cairo_move_to(cairo, 0, y - 1)
  cairo_line_to(cairo, 337 - breakpoint_count * 2, y - 1)
  cairo_stroke(cairo)
end
function draw_ring(cairo, y, radius, breakpoints, max)
  local previous_angle = angle(0, max)
  cairo_set_source_rgba(cairo, rgba(config['fg_color'], config['fg_alpha']))
  for breakpoint_index in pairs(breakpoints) do
    local breakpoint_angle = angle(breakpoints[breakpoint_index], max)
    if breakpoint_angle > previous_angle then
      cairo_set_line_width(cairo, (#breakpoints - breakpoint_index) * 2 + 6)
      cairo_arc(
        cairo,
        400,
        y,
        radius + #breakpoints - breakpoint_index,
        previous_angle,
        breakpoint_angle
      )
      cairo_stroke(cairo)
      previous_angle = breakpoint_angle + math.pi / 135
    end
  end
  cairo_set_line_width(cairo, 6)
  cairo_set_source_rgba(cairo, rgba(config['bg_color'], config['bg_alpha']))
  cairo_arc(cairo, 400, y, radius, previous_angle, angle(max, max))
  cairo_stroke(cairo)
end
function conky_rings()
  if conky_window == nil then
    return
  end
  local cairo = cairo_create(cairo_xlib_surface_create(
    conky_window.display,
    conky_window.drawable,
    conky_window.visual,
    conky_window.width,
    conky_window.height
  ))
  for group_index in pairs(groups) do
    local y = group_index * 160 - 80
    local breakpoint_count = 0
    for ring_index in pairs(groups[group_index]) do
      local breakpoints = {}
      local ring = groups[group_index][ring_index]
      local value = evaluate(ring['command'], ring['log'])
      if ring['breakpoints'] ~= nil then
        local position = 0
        for breakpoint_index in pairs(ring['breakpoints']) do
          local value = evaluate(ring['breakpoints'][breakpoint_index], ring['log'])
          if value == nil then
            break
          end
          position = position + value
          table.insert(breakpoints, position)
        end
      end
      if value ~= nil then
        table.insert(breakpoints, value)
      end
      breakpoint_count = math.max(breakpoint_count, #breakpoints)
      if #breakpoints ~= 0 then
        draw_ring(cairo, y, 68 - ring_index * 8, breakpoints, ring['max'])
      end
    end
    draw_line(cairo, y, breakpoint_count)
  end
end
