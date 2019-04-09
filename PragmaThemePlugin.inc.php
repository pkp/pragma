<?php

/**
 * @file plugins/themes/pragma/PragmaThemePlugin.inc.php
 *
 * Copyright (c) 2014-2018 Simon Fraser University
 * Copyright (c) 2003-2018 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class PragmaThemePlugin
 * @ingroup plugins_themes_pragma
 *
 * @brief Pragma theme
 */

import('lib.pkp.classes.plugins.ThemePlugin');
class PragmaThemePlugin extends ThemePlugin {

	public function init() {

		// Add navigation menu areas for this theme
		$this->addMenuArea(array('primary', 'user'));

		// Adding styles (JQuery UI, Bootstrap, Tag-it)
		$this->addStyle('app-css', 'resources/dist/app.min.css');
		$this->addStyle('less', 'resources/less/import.less');

		// Fonts
		$this->addStyle(
			'fonts',
			'https://fonts.googleapis.com/css?family=Alegreya:400,400i,700,700i|Work+Sans:400,700',
			array('baseUrl' => ''));

		// Adding scripts (JQuery, Popper, Bootstrap, JQuery UI, Tag-it, Theme's JS)
		$this->addScript('app-js', 'resources/dist/app.min.js');

		HookRegistry::register ('TemplateManager::display', array($this, 'addSiteWideData'));
		HookRegistry::register ('TemplateManager::display', array($this, 'addIndexJournalData'));
		HookRegistry::register ('TemplateManager::display', array($this, 'checkCurrentPage'));
	}

	/**
	 * Get the display name of this theme
	 * @return string
	 */
	public function getDisplayName() {
		return __('plugins.themes.pragma.name');
	}

	/**
	 * Get the description of this plugin
	 * @return string
	 */
	public function getDescription() {
		return __('plugins.themes.pragma.description');
	}

	/**
	 * @param $hookname string
	 * @param $args array
	 */
	public function addSiteWideData($hookname, $args) {
		$templateMgr = $args[0];

		$request = $this->getRequest();
		$journal = $request->getJournal();

		if (!defined('SESSION_DISABLE_INIT')) {

			// Check locales
			if ($journal) {
				$locales = $journal->getSupportedLocaleNames();
			} else {
				$locales = $request->getSite()->getSupportedLocaleNames();
			}

			// Load login form
			$loginUrl = $request->url(null, 'login', 'signIn');
			if (Config::getVar('security', 'force_login_ssl')) {
				$loginUrl = PKPString::regexp_replace('/^http:/', 'https:', $loginUrl);
			}

			$orcidImageUrl = $this->getPluginPath() . '/templates/images/orcid.png';

			if ($request->getContext()) {
				$templateMgr->assign('pragmaHomepageImage', $journal->getLocalizedSetting('homepageImage'));
			}

			$templateMgr->assign(array(
				'languageToggleLocales' => $locales,
				'loginUrl' => $loginUrl,
				'orcidImageUrl' => $orcidImageUrl
			));
		}
	}

	/**
	 * @param $hookname string
	 * @param $args array
	 */
	public function addIndexJournalData($hookname, $args) {
		$templateMgr = $args[0];
		$template = $args[1];

		if ($template !== 'frontend/pages/indexJournal.tpl') return false;

		$request = $this->getRequest();
		$journal = $request->getJournal();
		$issueDao = DAORegistry::getDAO('IssueDAO');

		import('lib.pkp.classes.db.DBResultRange');
		$range = new DBResultRange(4, 1);
		$recentIssuesObject = $issueDao->getIssues($journal->getId(), $range);

		$recentIssues = array();
		while ($recentIssue = $recentIssuesObject->next()) {
			$recentIssues[] = $recentIssue;
		}

		$templateMgr->assign('recentIssues', $recentIssues);
	}


	/**
	 * @param $hookname string
	 * @param $args array
	 */
	public function checkCurrentPage($hookname, $args) {
		$templateMgr = $args[0];

		$request = $this->getRequest();
		$router = $request->getRouter();
		$handler = $router->getHandler();

		$templateMgr->registerPlugin('function', 'pragma_item_active', array($this, 'isActiveItem'));

	}

	/**
	 * @param $params array
	 * @param $smarty Smarty_Internal_Template
	 * @return string
	 */
	public function isActiveItem($params, $smarty) {
		$navigationMenuItem = $params['item'];
		$emptyMarker = '';
		$activeMarker = ' active';

		if (!$navigationMenuItem instanceof NavigationMenuItem && $navigationMenuItem->getIsDisplayed()) return $emptyMarker;

		// Do not add an active marker if it's a dropdown menu
		if ($navigationMenuItem->getIsChildVisible()) return $emptyMarker;

		// Retrieve URL and its components for a menu item
		$itemUrl = $navigationMenuItem->getUrl();

		// Get URL of the current page
		$request = $this->getRequest();
		$currentUrl = $request->getCompleteUrl();

		// Check whether menu item points to the current page
		switch ($navigationMenuItem->getType()) {
			case NMI_TYPE_CURRENT:
				$issue = $smarty->getTemplateVars('issue');
				if ($issue && $issue->getCurrent()) return $activeMarker;
				break;
			default:
				if ($currentUrl === $itemUrl) return $activeMarker;
				break;
		}

		return $emptyMarker;
	}
}
