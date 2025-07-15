return {
	{
		"theHamsta/nvim-dap-virtual-text",
		opts = {
			-- enabled = true, -- enable this plugin (the default)
			-- enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
			-- highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
			-- highlight_new_as_changed = true, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
			-- show_stop_reason = true, -- show stop reason when stopped for exceptions
			-- commented = true, -- prefix virtual text with comment string
			-- only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
			-- all_references = true, -- show virtual text on all all references of the variable (not only definitions)
			-- clear_on_continue = false, -- clear virtual text on "continue" (might cause flickering when stepping)
		},
	},
}
