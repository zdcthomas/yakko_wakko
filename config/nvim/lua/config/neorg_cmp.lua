--local source = {}
--source.new = function()
--	return setmetatable({}, { __index = source })
--end

--source._validate_options = function(_, params)
--	local opts = vim.tbl_deep_extend("keep", params.option, defaults)
--	vim.validate({
--		trailing_slash = { opts.trailing_slash, "boolean" },
--		get_cwd = { opts.get_cwd, "function" },
--	})
--	return opts
--end

-----Return this source is available in current context or not. (Optional)
-----@return boolean
--function source:is_available()
--	return true
--end

-----Return the debug name of this source. (Optional)
-----@return string
--function source:get_debug_name()
--	return "debug name"
--end

-----Return keyword pattern for triggering completion. (Optional)
-----If this is ommited, nvim-cmp will use default keyword pattern. See |cmp-config.completion.keyword_pattern|
-----@return string
---- function source:get_keyword_pattern()
----   return [[\k\+]]
---- end

-----Return trigger characters for triggering completion. (Optional)
--function source:get_trigger_characters()
--	return { "{", ":" }
--end

-----Invoke completion. (Required)
-----@param params cmp.SourceCompletionApiParams
-----@param callback fun(response: lsp.CompletionResponse|nil)
-----@class lsp.CompletionList
-----@field public isIncomplete boolean
-----@field public items lsp.CompletionItem[]

-----@class lsp.CompletionItem
-----@field public label string
-----@field public labelDetails lsp.CompletionItemLabelDetails|nil
-----@field public kind lsp.CompletionItemKind|nil
-----@field public tags lsp.CompletionItemTag[]|nil
-----@field public detail string|nil
-----@field public documentation lsp.MarkupContent|string|nil
-----@field public deprecated boolean|nil
-----@field public preselect boolean|nil
-----@field public sortText string|nil
-----@field public filterText string|nil
-----@field public insertText string|nil
-----@field public insertTextFormat lsp.InsertTextFormat
-----@field public insertTextMode lsp.InsertTextMode
-----@field public textEdit lsp.TextEdit|lsp.InsertReplaceTextEdit|nil
-----@field public additionalTextEdits lsp.TextEdit[]
-----@field public commitCharacters string[]|nil
-----@field public command lsp.Command|nil
-----@field public data any|nil
--function source:complete(params, callback)
--	Pr(params)
--	callback({
--		{ label = "January", kind = 12, detail = "this is some detail", documentation = "fuck you" },
--		{ label = "February", kind = 15 },
--		{ label = "March", kind = 17 },
--		{ label = "April" },
--		{ label = "May" },
--		{ label = "June" },
--		{ label = "July" },
--		{ label = "August" },
--		{ label = "September" },
--		{ label = "October" },
--		{ label = "November" },
--		{ label = "December" },
--	})
--end

-----Resolve completion item. (Optional)
-----@param completion_item lsp.CompletionItem
-----@param callback fun(completion_item: lsp.CompletionItem|nil)
--function source:resolve(completion_item, callback)
--	callback(completion_item)
--end

-----Execute command after item was accepted.
-----@param completion_item lsp.CompletionItem
-----@param callback fun(completion_item: lsp.CompletionItem|nil)
--function source:execute(completion_item, callback)
--	callback(completion_item)
--end

-----Register custom source to nvim-cmp.
--return function()
--	require("cmp").register_source("month", source.new())
--end
