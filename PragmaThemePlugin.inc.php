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
		/* Additional theme options */
		// Changing theme primary color
		$this->addOption('primaryColor', 'colour', array(
			'label' => 'plugins.themes.pragma.option.primaryColor.label',
			'description' => 'plugins.themes.pragma.option.primaryColor.description',
			'default' => '#A8DCDD',
		));

		$additionalLessVariables = [];
		if ($this->getOption('primaryColor') !== '#A8DCDD') {
			$additionalLessVariables[] = '@primary-colour:' . $this->getOption('primaryColor') . ';';
		}

		// Add navigation menu areas for this theme
		$this->addMenuArea(array('primary', 'user'));

		// Adding styles (JQuery UI, Bootstrap, Tag-it)
		$this->addStyle('app-css', 'resources/dist/app.min.css');
		$this->addStyle('stylesheet', 'resources/less/import.less');
		$this->modifyStyle('stylesheet', array('addLessVariables' => join($additionalLessVariables)));

		// Fonts
		$this->addStyle(
			'fonts',
			'https://fonts.googleapis.com/css?family=Alegreya:400,400i,700,700i|Work+Sans:400,700',
			array('baseUrl' => ''));

		// Adding scripts (JQuery, Popper, Bootstrap, JQuery UI, Tag-it, Theme's JS)
		$this->addScript('app-js', 'resources/dist/app.min.js');

		HookRegistry::register ('TemplateManager::display', array($this, 'addSiteWideData'));
		HookRegistry::register ('TemplateManager::display', array($this, 'addIndexJournalData'));
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
}
