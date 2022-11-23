-- Core settings
require('raelum.core.keymaps')
require('raelum.core.options')

-- Install plugins (needs to be above plugin configs)
require('raelum.plugins.install')

-- Plugin configuration
require('raelum.plugins.configs.gruvbox')
require('raelum.plugins.configs.lualine')
require('raelum.plugins.configs.gitsigns')
require('raelum.plugins.configs.telescope')

-- Make generic color adjusts after loading all plugins (including themes)
require('raelum.core.colors')
