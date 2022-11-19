-- Core settings
require('am-eve.core.keymaps')
require('am-eve.core.options')

-- Install plugins (needs to be above plugin configs)
require('am-eve.plugins-setup')

-- Plugin configuration
require('am-eve.plugins.gruvbox')
require('am-eve.plugins.lualine')
require('am-eve.plugins.gitsigns')
require('am-eve.plugins.telescope')
