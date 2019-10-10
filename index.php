<?php
	
	/**
	 * @file plugins/themes/pragma/index.php
	 *
	 * Copyright (c) 2014-2019 Simon Fraser University
	 * Copyright (c) 2003-2019 John Willinsky
	 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
	 *
	 * @ingroup plugins_themes_pragma
	 * @brief Wrapper for Pragma theme plugin.
	 *
	 */
	
	require_once('PragmaThemePlugin.inc.php');
	
	return new PragmaThemePlugin();
