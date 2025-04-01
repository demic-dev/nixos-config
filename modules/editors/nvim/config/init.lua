-- Parse command-line arguments to determine which configuration to use
local function parse_args()
  local args = vim.v.argv
  local conf_type = "c"  -- Default to coding configuration (ecosse3/nvim)
  
  for i = 1, #args do
    if args[i] == "--conf" and i < #args then
      if args[i+1] == "w" then
        conf_type = "w"  -- Writing configuration (MiragianCycle/OVIWrite)
      end
      break
    end
  end
  
  return conf_type
end

-- Set up environment for the selected configuration
local function load_configuration(conf_type)
  local config_dir = vim.fn.stdpath("config")
  local conf_path
  
  if conf_type == "w" then
    -- Load writing configuration
    conf_path = config_dir .. "/miragianCycle"
    -- vim.g.active_config = "writing"
    -- print("Loading writing configuration (MiragianCycle/OVIWrite)")
  else
    -- Load coding configuration
    conf_path = config_dir .. "/ecosse3"
    -- vim.g.active_config = "coding"
    -- print("Loading coding configuration (ecosse3/nvim)")
  end
  
  -- Add the configuration directory to runtimepath
  vim.opt.runtimepath:prepend(conf_path)
  
  -- Load the configuration's init.lua
  dofile(conf_path .. "/init.lua")
end

-- Main execution - load the appropriate configuration
load_configuration(parse_args())
