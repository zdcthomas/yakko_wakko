local Module = {}

Module.trees = {

	smallest = [[
		            
		      /&*/  
		  &/&/*/ &  
		  &/ \}/ {_&
		*@\_{*\    *
		    {}      
		    {{}     
		=-~{ .-^-\  
		    `}      
		      \     
]],

	baby = [[
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
]],

	teen = [[
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
]],

	adult = [[
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
]],

	middle_aged = [[
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
]],

	old = [[
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
]],

	older = [[
		                              
		                              
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
]],
}

Module.config = {
	default = {},
}

Module.pick = function(hour_of_day, headers)
	local default = Module.default
	local win_height = vim.fn.winheight("%")
	local win_width = vim.fn.winwidth("%")

	-- if (win_width > 120) and (win_height > 50) then
	-- 	boxes = trees["boxed"]
	-- else

	-- end

	local hour = tonumber(hour_of_day)
	local interval = 24 / #headers
	local index = math.floor(hour / interval)
	local ascii = headers[index + 1]

	if not ascii then
		ascii = default
	end
	if type(ascii) == "string" then
		return vim.split(ascii, "\n")
	elseif type(ascii) == "table" then
		return ascii
	else
		vim.notify("Starter: Bad data type passed to headers", "ERROR")
	end
end

return Module
