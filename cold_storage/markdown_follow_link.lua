-- Thanks https://github.com/jghauser !!

local fn = vim.fn
local cmd = vim.cmd
local loop = vim.loop
local ts_utils = require 'nvim-treesitter.ts_utils'

local Plugin = {}

local function get_link()
  local node_at_cursor = ts_utils.get_node_at_cursor()
  print("Node from TS: ", node_at_cursor:type())
  local parent_node = node_at_cursor:parent()
  print("Parent Node from TS: ", parent_node:type())
  if not node_at_cursor or not parent_node then
    return
  elseif parent_node:type() == 'link_destination' then
    print("Link Destination node")
    return ts_utils.get_node_text(node_at_cursor, 0)[1]
  elseif parent_node:type() == 'link_text' then
    print("Link text node")
    return ts_utils.get_node_text(ts_utils.get_next_node(parent_node), 0)[1]
  elseif node_at_cursor:type() == 'link' then
    print("Link node")
    local child_nodes = ts_utils.get_named_children(node_at_cursor)
    for k, v in pairs(child_nodes) do
      if v:type() == 'link_destination' then
        return ts_utils.get_node_text(v)[1]
      end
    end
  else
    return
  end
end

local function is_link()
  local node_at_cursor = ts_utils.get_node_at_cursor()
  local parent_node = node_at_cursor:parent()

  if not node_at_cursor or not parent_node then
    return false
  elseif parent_node:type() == 'link_destination' then
    return true
  elseif parent_node:type() == 'link_text' then
    return true
  elseif node_at_cursor:type() == 'link' then
    return true
  else
    return false
  end
end

local function get_node()
  local node_at_cursor = ts_utils.get_node_at_cursor()
  local parent_node = node_at_cursor:parent()

  if not node_at_cursor or not parent_node then
    return
  elseif parent_node:type() == 'link_destination' then
    return ts_utils.get_node_text(node_at_cursor, 0)[1]
  elseif parent_node:type() == 'link_text' then
    return ts_utils.get_node_text(ts_utils.get_next_node(parent_node), 0)[1]
  elseif node_at_cursor:type() == 'link' then
    local child_nodes = ts_utils.get_named_children(node_at_cursor)
    for k, v in pairs(child_nodes) do
      if v:type() == 'link_destination' then
        return ts_utils.get_node_text(v)[1]
      end
    end
  else
    return
  end
end

local function resolve_link(link)
  if string.sub(link,1,1) == [[/]] then
    return link
  else
    return fn.expand('%:p:h') .. [[/]] .. link
  end
end


local function create_link()
  -- if mode 
  local word = vim.fn.expand("<cword>")
  local link = string.lower(word:gsub(" ", "_"))
  local link_text = "[" .. word .. "]" .. "(" .. link .. ".md)"
  vim.cmd('normal ""diwi' .. link_text)
  print(link_text)
end


local function starts_with(text, prefix)
  return text:find(prefix, 1, true) == 1
end

local function is_web_link(link)
  return starts_with(link, "http") or starts_with(link, "www")
end

local function open_web_link(link)
  print("Open this web link in browser:", link)
end

local function follow_local_link(link)
  link = resolve_link(link)
  print("resolved file link: ", link)
  local fd = loop.fs_open(link, "r", 438)
  if fd then
    local stat = loop.fs_fstat(fd)
    if not stat or not stat.type == 'file' or not loop.fs_access(link, 'R') then
      loop.fs_close(fd)
    else
      loop.fs_close(fd)
      cmd(string.format('%s %s', 'e', fn.fnameescape(link)))
    end
  end

end

function Plugin.handle_link_or_follow()
  -- Change this to just return node type and then match on that here
  local link = get_link()
  print("Link: ", link)
  if link then
    if is_web_link(link) then
      open_web_link(link)
    else
      follow_local_link(link)
    end
  else
    create_link()
  end
end

return Plugin
