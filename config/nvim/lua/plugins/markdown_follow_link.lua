-- Thanks https://github.com/jghauser !!

local fn = vim.fn
local cmd = vim.cmd
local loop = vim.loop
local ts_utils = require 'nvim-treesitter.ts_utils'

local Plugin = {}

local function get_link()
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

    print("Parent node type", parent_node:type())
    for index, node in pairs(ts_utils.get_named_children(parent_node)) do
      print(index)
      print(node)
      for ind, text in pairs(ts_utils.get_node_text(node, 0)) do
        print(ind, text)
      end
      -- for index_sub_node, sub_node in pairs() do
      -- end
      -- for x,y in
      --   pairs(ts_utils.get_node_text(ts_utils.get_next_node(node_at_cursor), 0))
      --   do print(x) print(y) 
      -- end
    end
    print("node type", node_at_cursor:type())
    return
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
    print("parent node type" , parent_node:type())
    print("cursor node type", node_at_cursor:type())
    print("parent_node", ts_utils.get_node_text(ts_utils.get_next_node(parent_node), 0))
    return
  end
end

local function resolve_link(link)
  print("iinitial link in resolve link", link)
  if string.sub(link,1,1) == [[/]] then
    return link
  else
    return fn.expand('%:p:h') .. [[/]] .. link
  end
end

function Plugin.follow_link(foo)
  if foo then
    print("arg", foo)
  end
  print("called follow_link")
  local link = get_link()

  print("get link の link:", link)
  if link then
    link = resolve_link(link)
    print(link)
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
end

return Plugin
