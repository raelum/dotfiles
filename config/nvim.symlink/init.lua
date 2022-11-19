-- Core settings
require('raelum.core.keymaps')
require('raelum.core.options')

-- Install plugins (needs to be above plugin configs)
require('raelum.plugins-setup')

-- Plugin configuration
require('raelum.plugins.gruvbox')
require('raelum.plugins.lualine')
require('raelum.plugins.gitsigns')
require('raelum.plugins.telescope')
