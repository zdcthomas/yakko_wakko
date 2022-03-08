local M = {}

function M.menu()
	local Menu = require("nui.menu")
	local event = require("nui.utils.autocmd").event

	local menu = Menu({
		position = "20%",
		size = {
			width = 20,
			height = 2,
		},
		relative = "editor",
		border = {
			style = "single",
			text = {
				top = "Choose Something",
				top_align = "center",
			},
		},
		win_options = {
			winblend = 10,
			winhighlight = "Normal:Normal",
		},
	}, {
		lines = {
			Menu.item("Item 1"),
			Menu.item("Item 2"),
			Menu.separator("Menu Group", {
				char = "-",
				text_align = "right",
			}),
			Menu.item("Item 3"),
		},
		max_width = 20,
		keymap = {
			focus_next = { "j", "<Down>", "<Tab>" },
			focus_prev = { "k", "<Up>", "<S-Tab>" },
			close = { "<Esc>", "<C-c>" },
			submit = { "<CR>", "<Space>" },
		},
		on_close = function()
			print("CLOSED")
		end,
		on_submit = function(item)
			print("SUBMITTED", vim.inspect(item))
		end,
	})

	-- mount the component
	menu:mount()

	-- close menu when cursor leaves buffer
	menu:on(event.BufLeave, menu.menu_props.on_close, { once = true })
end

function M.pop()
	local Popup = require("nui.popup")
	local popup = Popup({
		position = "50%",
		size = {
			width = 80,
			height = 40,
		},
		enter = true,
		focusable = true,
		zindex = 50,
		relative = "editor",
		border = {
			highlight = "FloatBorder",
			padding = {
				top = 2,
				bottom = 2,
				left = 3,
				right = 3,
			},
			style = "rounded",
			text = {
				top = " I am top title ",
				top_align = "center",
				bottom = "I am bottom title",
				bottom_align = "left",
			},
		},
		buf_options = {
			modifiable = true,
			readonly = false,
		},
		win_options = {
			winblend = 10,
			winhighlight = "Normal:Normal",
		},
	})

	popup:mount()
	popup:map("n", "q", function()
		popup:unmount()
	end, { noremap = true })
	popup:show()
end

function M.tree()
	local NuiTree = require("nui.tree")
	local NuiLine = require("nui.line")
	local Split = require("nui.split")

	local split = Split({
		relative = "win",
		position = "bottom",
		size = 30,
	})

	split:mount()

	-- quit
	split:map("n", "q", function()
		split:unmount()
	end, { noremap = true })

	local tree = NuiTree({
		winid = split.winid,
		nodes = {
			NuiTree.Node({ text = "a" }),
			NuiTree.Node({ text = "b" }, {
				NuiTree.Node({ text = "b-1" }),
				NuiTree.Node({ text = "b-2" }, {
					NuiTree.Node({ text = "b-1-a" }),
					NuiTree.Node({ text = "b-2-b" }),
				}),
			}),
			NuiTree.Node({ text = "c" }, {
				NuiTree.Node({ text = "c-1" }),
				NuiTree.Node({ text = "c-2" }),
			}),
		},
		prepare_node = function(node)
			local line = NuiLine()

			line:append(string.rep("  ", node:get_depth() - 1))

			if node:has_children() then
				line:append(node:is_expanded() and " " or " ", "SpecialChar")
			else
				line:append("  ")
			end

			line:append(node.text)

			return line
		end,
	})

	local map_options = { noremap = true, nowait = true }

	-- print current node
	split:map("n", "<CR>", function()
		local node = tree:get_node()
		print(vim.inspect(node))
	end, map_options)

	-- collapse current node
	split:map("n", "h", function()
		local node = tree:get_node()

		if node:collapse() then
			tree:render()
		end
	end, map_options)

	-- collapse all nodes
	split:map("n", "H", function()
		local updated = false

		for _, node in pairs(tree.nodes.by_id) do
			updated = node:collapse() or updated
		end

		if updated then
			tree:render()
		end
	end, map_options)

	-- expand current node
	split:map("n", "l", function()
		local node = tree:get_node()

		if node:expand() then
			tree:render()
		end
	end, map_options)

	-- expand all nodes
	split:map("n", "L", function()
		local updated = false

		for _, node in pairs(tree.nodes.by_id) do
			updated = node:expand() or updated
		end

		if updated then
			tree:render()
		end
	end, map_options)

	-- add new node under current node
	split:map("n", "a", function()
		local node = tree:get_node()
		tree:add_node(
			NuiTree.Node({ text = "d" }, {
				NuiTree.Node({ text = "d-1" }),
			}),
			node:get_id()
		)
		tree:render()
	end, map_options)

	-- delete current node
	split:map("n", "d", function()
		local node = tree:get_node()
		tree:remove_node(node:get_id())
		tree:render()
	end, map_options)

	tree:render()
end

return M
