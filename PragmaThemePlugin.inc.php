<?php

/**
 * @file plugins/themes/pragma/PragmaThemePlugin.inc.php
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
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
		// Change theme primary color
		$this->addOption('baseColour', 'FieldColor', array(
			'label' => __('plugins.themes.default.option.colour.label'),
			'default' => '#A8DCDD',
		));

		$baseColour = $this->getOption('baseColour');

		$additionalLessVariables = [];
		if ($baseColour !== '#A8DCDD') {
			$additionalLessVariables[] = '@primary-colour:' . $baseColour . ';';
			$additionalLessVariables[] = '@secondary-colour: darken(@primary-colour, 50%);';
		}

		// Update contrast colour based on primary colour
		if ($this->isColourDark($this->getOption('baseColour'))) {
			$additionalLessVariables[] = '
				@contrast-colour: rgba(255, 255, 255, 0.95);
				@secondary-contrast-colour: rgba(255, 255, 255, 0.75);
				@tertiary-contrast-colour: rgba(255, 255, 255, 0.65);
			';
		}

		$themeUrl = $this->getPluginPath();
		$additionalLessVariables[] = "@themeUrl: '$themeUrl';";

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

		// Styles for HTML galleys
		$this->addStyle('htmlGalley', 'resources/less/import.less', array('contexts' => 'htmlGalley'));
		$this->modifyStyle('htmlGalley', array('addLessVariables' => join($additionalLessVariables)));

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
		$baseColour = $this->getOption('baseColour');

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
				'orcidImageUrl' => $orcidImageUrl,
				'baseColour' => $baseColour,
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

		$recentIssuesIterator = Services::get('issue')->getMany([
			'contextId' => $this->getRequest()->getContext()->getId(),
			'isPublished' => true,
			'count' => 4
		]);

		// Exclude the current issue from the list
		$recentIssuesAll = iterator_to_array($recentIssuesIterator);
		$recentIssues = [];
		foreach ($recentIssuesAll as $issue) {
			if (!$issue->getCurrent()) {
				$recentIssues[] = $issue;
			}
		}

		$templateMgr->assign('recentIssues', $recentIssues);
	}


	/**
	 * @param $hookname string
	 * @param $args array
	 */
	public function checkCurrentPage($hookname, $args) {
		$templateMgr = $args[0];
		// TODO check the issue with multiple calls of the hook on settings/website
		if (!isset($templateMgr->registered_plugins["function"]["pragma_item_active"])) {
			$templateMgr->registerPlugin('function', 'pragma_item_active', array($this, 'isActiveItem'));
		}

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

		// Get URL of the current page
		$request = $this->getRequest();
		$currentUrl = $request->getCompleteUrl();
		$currentPage = $request->getRequestedPage();

		if (!($navigationMenuItem instanceof NavigationMenuItem && $navigationMenuItem->getIsDisplayed())) {
			if (is_string($navigationMenuItem)) {
				$navigationMenuItemIndex = preg_replace('/index$/', '', $navigationMenuItem);
				$navigationMenuItemSlash = preg_replace('/\/index$/', '', $navigationMenuItem);
				if ($navigationMenuItem == $currentUrl || $navigationMenuItemIndex == $currentUrl || $navigationMenuItemSlash == $currentUrl) {
					return $activeMarker;
				} else {
					return $emptyMarker;
				}
			} else {
				return $emptyMarker;
			}
		}

		// Do not add an active marker if it's a dropdown menu
		if ($navigationMenuItem->getIsChildVisible()) return $emptyMarker;

		// Retrieve URL and its components for a menu item
		$itemUrl = $navigationMenuItem->getUrl();

		// Check whether menu item points to the current page
		switch ($navigationMenuItem->getType()) {
			case NMI_TYPE_CURRENT:
				$issue = $smarty->getTemplateVars('issue');
				if ($issue && $issue->getCurrent() && $currentPage == "issue") return $activeMarker;
				break;
			default:
				if ($currentUrl === $itemUrl) return $activeMarker;
				break;
		}

		return $emptyMarker;
	}
}
