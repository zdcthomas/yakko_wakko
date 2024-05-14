local conf = {}
local startify = "startify"
local dashboard = "dashboard"
local mini = "mini"
local starter = mini

local function center(list)
	return vim.fn["startify#center"](list)
end

local running_man = [[
	  \                           /      
	   \                         /       
	    \                       /        
	     ]                     [    '|  
	     ]               &&&&  [   /  |  
	     ]___           &&&&&&_[ '   |  
	     ]  ]\          &&&/[  [ |:   |  
	     ]  ] \          &/ [  [ |:   |  
	     ]  ]  ]         [  [  [ |:   |  
	     ]  ]  ]__     __[  [  [ |:   |  
	     ]  ]  ] ]\ _ /[ [  [  [ |:   |  
	     ]  ]  ] ] (#) [ [  [  [ :===='  
	     ]  ]  ]_].nHn.[_[  [  [         
	     ]  ]  ]  HHHHH. [  [  [         
	     ]  ] /   `HH("N  \ [  [         
	     ]__]/     HHH  "  \[__[         
	     ]         NNN         [         
	     ]         N/"         [         
	     ]         N H         [         
	    /          N            \        
	   /           q            \       
	  /                           \      
	]]

local generate_trees = function()
	local smallest = [[
		            
		      /&*/  
		  &/&/*/ &  
		  &/ \}/ {_&
		*@\_{*\    *
		    {}      
		    {{}     
		=-~{ .-^-\  
		    `}      
		      \     
]]

	local baby = [[
		        *      
		  &     &&&    
		&&| &&|/*@&   
		  &/&&*/ &/_&  
		  && \\/ {_&  @
		*@\_{*&//      
		    ` \{      
		    } }        
		    {{}        
		-=-~{ .-^-\    
		    `}         
		      \        
]]

	local teen = [[
		         &&           
		       & \/&          
		     && \/& &&&       
		    &&|/  |/  &&     
		 *&_ &&/___/  /_&  _  
		&_\\    \\/ { &|__/ * 
		   \\___{*&/ /       _
		       ` \{____&__&/*
		        } }/          
		        }{            
		       {{}            
		 --=-~{ .-^-\__     
		       `}             
		        {             
]]

	local adult = [[
		           &&                 
		         &&&&&                
		   &  &&&\/& &&&             
		&-\* &&&|/ *|/& &&           
		 . *&_ &&/   / /_&  &&       
		  &_\\    \\  { &|__&_&/_&    
		 ^   \\_&_{*&/ /          &&& 
		         ` \{__&_&__&_&_/_&& 
		          } }{ * @  &\\'      
		          }{{         \'_&__& 
		         {}{           \ `&\&&
		         {{}             '&@  
		   --=-~{ .-^-\__           
		         `}                   
		          {                   
]]

	local middle_aged = [[
		            &&                 
		          &&&&&                
		        &&&\/& &&&             
		       &&|/  |/& &&           
		    *&_ &&/   /  /_&  &&       
		   &_\\    \\  { &|__&_&/_&    
		      \\_&_{*&/ /          &&& 
		         ` \{__&_&__&_&_/_&& 
		  &        } }{      &\\'      
		           }{{         \'_&__& 
		          {}{           \ `&\&&
		          {{}             '&&  
		    --=-~{ .-^-\__           
		&        `}                   
		  .        {                   
]]

	local old = [[
		            _                 
		             \                
		          &\/{  _/            
		       &_|/} {/& &&          
		    *&_  \/ | /  /_&  &&      
		   &_\\   \ \  { &|__&_&/_&   
		      \\_\_{*&/ /          &&&
		         ` \{__&_&__&_&_/_&&
		  &        } }{      &\\'     
		           }{{         \'____&
		          {}{           \ ` \ 
		          {{}           *     
		 . &-.&-~{ .-^-*__          
		&   @    `}   .& .      _@&& 
		  .        {     .  .    \**  
]]

	local older = [[
		                              
		                              
		          &\/{  _/      .&    
		       &_  /} {/  _&          
		    *__  \/ | /  /    &       
		    _\\   \ \{ { /\__/        
		   /  \__\_{*_/ /     \     .*
		   |   }  `/\{__&__/__       
		           } }{ }     \       
		       .   }{{   *           
		   & .    {}{                 
		          {{}      .         
		 . _-._-~{ .-^-*__   *      
		   _/   /_}\ \_    \_   _    
		  /  .     {      . .     \*  
]]

	local old_boxed = [[
		._____. ._____. .____________________. ._____. ._____.
		| ._. | | ._. | | .________________. | | ._. | | ._. |
		| !_| |_|_|_! | | !________________! | | !_| |_|_|_! |
		!___| |_______! !____________________! !___| |_______!
		.___|_|_| |________________________________|_|_| |___.
		| ._____| |____________________________________| |_. |
		| !_! | | |                                | | ! !_! |
		!_____! | |             _                  | | !_____!
		._____. | |              \                 | | ._____.
		| ._. | | |           &\/{  _/             | | | ._. |
		| | | | | |        &_|/} {/& &&           | | | | | |
		| | | | | |     *&_  \/ | /  /_&  &&       | | | | | |
		| | | | | |    &_\\   \ \  { &|__&_&/_&    | | | | | |
		| | | | | |       \\_\_{*&/ /          &&& | | | | | |
		| | | | | |          ` \{__&_&__&_&_/_&& | | | | | |
		| | | | | |   &        } }{      &\\'      | | | | | |
		| | | | | |            }{{         \'____& | | | | | |
		| | | | | |           {}{           \ ` \  | | | | | |
		| !_! | | |           {{}           *      | | ! !_! |
		!_____! | |  . &-.&-~{ .-^-*__           | | !_____!
		._____. | | &   @    `}   .& .      _@&&  | | ._____.
		| ._. | | |   .        {     .  .    \**   | | | ._. |
		| !_| |_|_|________________________________| |_|_|_! |
		!___| |____________________________________| |_______!
		.___|_|_| |___. .____________________. .___|_|_| |___.
		| ._____| |_. | | .________________. | | ._____| |_. |
		| !_! | | !_! | | !________________! | | !_! | | !_! |
		!_____! !_____! !____________________! !_____! !_____!
]]

	local middle_aged_boxed = [[
		._____. ._____. ._____________________. ._____. ._____.
		| ._. | | ._. | | ._________________. | | ._. | | ._. |
		| !_| |_|_|_! | | !_________________! | | !_| |_|_|_! |
		!___| |_______! !_____________________! !___| |_______!
		.___|_|_| |_________________________________|_|_| |___.
		| ._____| |_____________________________________| |_. |
		| !_! | | |                                 | | ! !_! |
		!_____! | |             &&                  | | !_____!
		._____. | |           &&&&&                 | | ._____.
		| ._. | | |         &&&\/& &&&              | | | ._. |
		| | | | | |        &&|/  |/& &&            | | | | | |
		| | | | | |     *&_ &&/   /  /_&  &&        | | | | | |
		| | | | | |    &_\\    \\  { &|__&_&/_&     | | | | | |
		| | | | | |       \\_&_{*&/ /          &&&  | | | | | |
		| | | | | |          ` \{__&_&__&_&_/_&&  | | | | | |
		| | | | | |   &        } }{      &\\'       | | | | | |
		| | | | | |            }{{         \'_&__&  | | | | | |
		| | | | | |           {}{           \ `&\&& | | | | | |
		| !_! | | |           {{}             '&&   | | ! !_! |
		!_____! | |     --=-~{ .-^-\__            | | !_____!
		._____. | | &        `}                    | | ._____.
		| ._. | | |   .        {                    | | | ._. |
		| !_| |_|_|_________________________________| |_|_|_! |
		!___| |_____________________________________| |_______!
		.___|_|_| |___. ._____________________. .___|_|_| |___.
		| ._____| |_. | | ._________________. | | ._____| |_. |
		| !_! | | !_! | | !_________________! | | !_! | | !_! |
		!_____! !_____! !_____________________! !_____! !_____!
]]

	local adult_boxed = [[
		._____. ._____. .____________________. ._____. ._____.
		| ._. | | ._. | | .________________. | | ._. | | ._. |
		| !_| |_|_|_! | | !________________! | | !_| |_|_|_! |
		!___| |_______! !____________________! !___| |_______!
		.___|_|_| |________________________________|_|_| |___.
		| ._____| |____________________________________| |_. |
		| !_! | | |                                | | ! !_! |
		!_____! | |            &&                  | | !_____!
		._____. | |          &&&&&                 | | ._____.
		| ._. | | |    &  &&&\/& &&&              | | | ._. |
		| | | | | | &-\* &&&|/ *|/& &&            | | | | | |
		| | | | | |  . *&_ &&/   / /_&  &&        | | | | | |
		| | | | | |   &_\\    \\  { &|__&_&/_&     | | | | | |
		| | | | | |  ^   \\_&_{*&/ /          &&&  | | | | | |
		| | | | | |          ` \{__&_&__&_&_/_&&  | | | | | |
		| | | | | |           } }{ * @  &\\'       | | | | | |
		| | | | | |           }{{         \'_&__&  | | | | | |
		| | | | | |          {}{           \ `&\&& | | | | | |
		| !_! | | |          {{}             '&@   | | ! !_! |
		!_____! | |    --=-~{ .-^-\__            | | !_____!
		._____. | |          `}                    | | ._____.
		| ._. | | |           {                    | | | ._. |
		| !_| |_|_|________________________________| |_|_|_! |
		!___| |____________________________________| |_______!
		.___|_|_| |___. .____________________. .___|_|_| |___.
		| ._____| |_. | | .________________. | | ._____| |_. |
		| !_! | | !_! | | !________________! | | !_! | | !_! |
		!_____! !_____! !____________________! !_____! !_____!
		                                                      
]]

	local teen_boxed = [[
		       /\          /\          /\       
		    /\//\\/\    /\//\\/\    /\//\\/\    
		 /\//\\\///\\/\//\\\///\\/\//\\\///\\/\ 
		//\\\//\/\\///\\\//\/\\///\\\//\/\\///\\
		\\//\/                            \/\\//
		 \/                &&                \/ 
		 /\              & \/&               /\ 
		//\\           && \/& &&&           //\\
		\\//         &&|/  |/  &&          \\//
		 \/       *&_ &&/___/  /_&  _        \/ 
		 /\      &_\\    \\/ { &|__/ *       /\ 
		//\\      \\___{*&/ /       _       //\\
		\\//        ` \{____&__&/*         \\//
		 \/               } }/               \/ 
		 /\                }{                /\ 
		//\\              {{}               //\\
		\\//        --=-~{ .-^-\__        \\//
		 \/                `}                \/ 
		 /\                {                 /\ 
		//\\/\                            /\//\\
		\\///\\/\//\\\///\\/\//\\\///\\/\//\\\//
		 \/\\///\\\//\/\\///\\\//\/\\///\\\//\/ 
		    \/\\//\/    \/\\//\/    \/\\//\/    
		       \/          \/          \/       
]]

	local baby_boxed = [[
		        <\/><\/><\/>        
		    <\/></\></\></\><\/>    
		    </\>            </\>    
		 <\/>        *         <\/> 
		 </\>    &     &&&     </\> 
		<\/>    &&| &&|/*@&    <\/>
		</\>    &/&&*/ &/_&     </\>
		<\/>   && \\/ {_&  @    <\/>
		</\>     *@\_{*&//      </\>
		<\/>       ` \{        <\/>
		</\>        } }         </\>
		<\/>        {{}         <\/>
		</\>    -=-~{ .-^-\     </\>
		 <\/>        `}        <\/> 
		 </\>        \         </\> 
		    <\/>            <\/>    
		    </\><\/><\/><\/></\>    
		        </\></\></\>        
]]

	local smallest_boxed = [[
		 .+"+.+"+.+"+.+"+. 
		(        &        )
		 )     &&|/      ( 
		(    &/&&*/ &     )
		 )  && \}/ {_&   ( 
		(     *@\_{*&     )
		 )      {}       ( 
		(       {{}       )
		 )  =-~{ .-^-\   ( 
		(       `}        )
		 )       \       ( 
		(                 )
		 "+.+"+.+"+.+"+.+" 
]]

	return {
		boxed = {
			smallest_boxed,
			baby_boxed,
			teen_boxed,
			adult_boxed,
			middle_aged_boxed,
			old_boxed,
		},
		unboxed = {
			smallest,
			baby,
			teen,
			adult,
			middle_aged,
			old,
		},
	}
end

local function pick_header(hour_of_day)
	local default = running_man
	local win_height = vim.fn.winheight("%")
	local win_width = vim.fn.winwidth("%")

	local boxes
	-- if (win_width > 120) and (win_height > 50) then
	-- 	boxes = trees["boxed"]
	-- else

	local trees = generate_trees()
	boxes = trees["unboxed"]
	-- end

	local hour = tonumber(hour_of_day)
	local interval = 24 / #boxes
	local index = math.floor(hour / interval)
	local ascii = boxes[index + 1]

	if not ascii then
		ascii = default
	end
	return ascii
end

return {
	{
		"echasnovski/mini.starter",
		version = false,
		cond = starter == mini,
		lazy = false,
		opts = function()
			local starter = require("mini.starter")

			return {
				-- Whether to open starter buffer on VimEnter. Not opened if Neovim was
				-- started with intent to show something else.
				autoopen = true,

				-- Whether to evaluate action of single active item
				evaluate_single = true,

				-- Items to be displayed. Should be an array with the following elements:
				-- - Item: table with <action>, <name>, and <section> keys.
				-- - Function: should return one of these three categories.
				-- - Array: elements of these three types (i.e. item, array, function).
				-- If `nil` (default), default items will be used (see |mini.starter|).
				items = {
					{
						{
							action = "enew",
							name = "Edit new buffer",
							section = "めいれい",
						},
						{
							action = "Lazy",
							name = "Lazy",
							section = "めいれい",
						},
						{
							action = "lua require('neogit').open({ kind = 'replace' })",
							name = "Git",
							section = "めいれい",
						},
						{
							action = "qall",
							name = "Quit Neovim",
							section = "めいれい",
						},
					},
					-- starter.sections.telescope(),
					starter.sections.recent_files(10, true),
				},

				-- Header to be displayed before items. Converted to single string via
				-- `tostring` (use `\n` to display several lines). If function, it is
				-- evaluated first. If `nil` (default), polite greeting will be used.
				header = pick_header(vim.fn.strftime("%H")),

				-- Footer to be displayed after items. Converted to single string via
				-- `tostring` (use `\n` to display several lines). If function, it is
				-- evaluated first. If `nil` (default), default usage help will be shown.
				footer = "",

				-- Array  of functions to be applied consecutively to initial content.
				-- Each function should take and return content for 'Starter' buffer (see
				-- |mini.starter| and |MiniStarter.content| for more details).
				content_hooks = {
					starter.gen_hook.adding_bullet("|> "),
					starter.gen_hook.aligning("center", "center"),
				},

				-- Characters to update query. Each character will have special buffer
				-- mapping overriding your global ones. Be careful to not add `:` as it
				-- allows you to go into command mode.
				query_updaters = "abcdefghijklmnopqrstuvwxyz0123456789_.",

				-- Whether to disable showing non-error feedback
				silent = true,
			}
		end,
	},
	{
		"glepnir/dashboard-nvim",
		cond = starter == dashboard,
		lazy = false,
		opts = function()
			local opts = {
				theme = "doom",
				shortcut_type = "number",
				disable_move = false,
				hide = {
					-- statusline = false,
					tabline = false,
					-- winbar = false,
				},
				config = {
					-- week_header = {
					-- 	enable = true, --boolean use a week header
					-- 	-- concat  --concat string after time string line
					-- 	-- append  --table append after time string line
					-- },
					header = vim.split(pick_header(vim.fn.strftime("%H")), "\n"),
	         -- stylua: ignore
					center = {
	             { action = ":!dmux",                                            desc = " Dmux",         desc_hl = "String", icon = " ", key = "d", },
	             { action = " Telescope oldfiles only_cwd=true",                 desc = " Recent files", desc_hl = "String", icon = " ", key = "o", },
	             { action = "lua require('neogit').open({ kind = 'replace' })",  desc = " Neogit",       desc_hl = "String", icon = " ", key = "g", },
	             { action = ":Lazy",                                             desc = " Lazy",         desc_hl = "String", icon = " ", key = "l", },
	             { action = ":q!",                                               desc = " Quit",         desc_hl = "String", icon = " ", key = "q", },
					},
					footer = function()
						local stats = require("lazy").stats()
						local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
						return {
							"⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms",
						}
					end,
				},
			}

			return opts
		end,
		dependencies = { { "nvim-tree/nvim-web-devicons" } },
	},
	{
		"mhinz/vim-startify",
		cond = starter == startify,
		branch = "center",
		lazy = false,
		config = function()
			vim.g.startify_center = 58
			vim.g.startify_commands = {
				{ l = { "Lazy", ":Lazy" } },
				{ d = { "Open dotfiles", ":!dmux ~/yakko_wakko" } },
				{ D = { "Dmux", ":!dmux" } },
				{ g = { "NeoGit", "lua require('neogit').open({ kind = 'replace' })" } },
			}

			vim.g.startify_lists = {
				{ type = "commands", header = center({ "めいれい" }) },
				{ type = "dir", header = center({ "MRU " .. vim.fn.getcwd() }) },
			}

			vim.g.sttartify_change_to_dir = 0
			vim.g.startify_change_to_vcs_root = 1
			local ascii = pick_header(vim.fn.strftime("%H"))
			vim.g.startify_custom_header = center(ascii)

			-- local startify_group = vim.api.nvim_create_augroup("startify", { clear = true })
			-- vim.api.nvim_create_autocmd({ "User" }, {
			-- 	group = startify_group,
			-- 	pattern = "StartifyReady",
			-- 	callback = function()
			-- 		vim.keymap.set("n", "-", function()
			-- 			vim.cmd("bwipe")
			-- 			vim.cmd("Dirvish")
			-- 		end, { silent = true, buffer = true })
			-- 	end,
			-- })
		end,
	},
}
