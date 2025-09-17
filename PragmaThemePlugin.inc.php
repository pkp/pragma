<?php

/**
 * @file plugins/themes/pragma/PragmaThemePlugin.inc.php
 *
 * Copyright (c) 2014-2025 Simon Fraser University
 * Copyright (c) 2003-2025 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class PragmaThemePlugin
 * @ingroup plugins_themes_pragma
 *
 * @brief Pragma theme
 */

use APP\facades\Repo;
use APP\issue\Collector;
use APP\services\NavigationMenuService;
use PKP\config\Config;
use PKP\facades\Locale;
use PKP\form\validation\FormValidatorAltcha;
use PKP\navigationMenu\NavigationMenuItem;
use PKP\plugins\ThemePlugin;

class PragmaThemePlugin extends ThemePlugin
{
    public function init()
    {
        /* Additional theme options */
        // Change theme primary color
        $this->addOption('baseColour', 'FieldColor', [
            'label' => __('plugins.themes.default.option.colour.label'),
            'default' => '#A8DCDD',
        ]);

        // Add usage stats display options
        $this->addOption('displayStats', 'FieldOptions', [
            'type' => 'radio',
            'label' => __('plugins.themes.pragma.option.displayStats.label'),
            'options' => [
                [
                    'value' => 'none',
                    'label' => __('plugins.themes.pragma.option.displayStats.none'),
                ],
                [
                    'value' => 'bar',
                    'label' => __('plugins.themes.pragma.option.displayStats.bar'),
                ],
                [
                    'value' => 'line',
                    'label' => __('plugins.themes.pragma.option.displayStats.line'),
                ],
            ],
            'default' => 'none',
        ]);

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
        $this->addMenuArea(['primary', 'user']);

        // Adding styles (JQuery UI, Bootstrap, Tag-it)
        $this->addStyle('app-css', 'resources/dist/app.min.css');
        $this->addStyle('stylesheet', 'resources/less/import.less');
        $this->modifyStyle('stylesheet', ['addLessVariables' => join("\n", $additionalLessVariables)]);

        // Adding scripts (JQuery, Popper, Bootstrap, JQuery UI, Tag-it, Theme's JS)
        $this->addScript('app-js', 'resources/dist/app.min.js');

        // Styles for HTML galleys
        $this->addStyle('htmlGalley', 'resources/less/import.less', ['contexts' => 'htmlGalley']);
        $this->modifyStyle('htmlGalley', ['addLessVariables' => join("\n", $additionalLessVariables)]);

        HookRegistry::add('TemplateManager::display', [$this, 'initializeTemplate']);
        HookRegistry::add('TemplateManager::display', [$this, 'addSiteWideData']);
        HookRegistry::add('TemplateManager::display', [$this, 'addIndexJournalData']);
        HookRegistry::add('TemplateManager::display', [$this, 'checkCurrentPage']);
    }

    /**
     * Initialize Template
     */
    public function initializeTemplate(string $hookname, array $args): bool
    {
        $templateMgr = $args[0];
        // The login link displays the login form in a modal, therefore the reCAPTCHA/ALTCHA must be available for all frontend routes
        $isCaptchaEnabled = Config::getVar('captcha', 'recaptcha') && Config::getVar('captcha', 'captcha_on_login');
        if ($isCaptchaEnabled) {
            $templateMgr->addJavaScript(
                'recaptcha',
                'https://www.recaptcha.net/recaptcha/api.js?hl=' . substr(Locale::getLocale(), 0, 2)
            );
            $templateMgr->assign('recaptchaPublicKey', Config::getVar('captcha', 'recaptcha_public_key'));
        }

        $altchaEnabled = Config::getVar('captcha', 'altcha') && Config::getVar('captcha', 'altcha_on_login');
        if ($altchaEnabled) {
            FormValidatorAltcha::addAltchaJavascript($templateMgr);
            FormValidatorAltcha::insertFormChallenge($templateMgr);
        }

        return false;
    }

    /**
     * Get the display name of this theme
     * @return string
     */
    public function getDisplayName(): string
    {
        return __('plugins.themes.pragma.name');
    }

    /**
     * Get the description of this plugin
     * @return string
     */
    public function getDescription(): string
    {
        return __('plugins.themes.pragma.description');
    }

    /**
     * @param $hookname string
     * @param $args array
     */
    public function addSiteWideData($hookname, $args)
    {
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
                $loginUrl = preg_replace('/^http:/u', 'https:', $loginUrl);
            }

            if ($request->getContext()) {
                $templateMgr->assign('pragmaHomepageImage', $journal->getLocalizedData('homepageImage'));
            }

            $templateMgr->assign([
                'languageToggleLocales' => $locales,
                'loginUrl' => $loginUrl,
                'baseColour' => $baseColour,
            ]);
        }
    }

    /**
     * @param $hookname string
     * @param $args array
     */
    public function addIndexJournalData($hookname, $args)
    {
        $templateMgr = $args[0];
        $template = $args[1];

        if ($template !== 'frontend/pages/indexJournal.tpl') {
            return false;
        }

        $contextId = $this->getRequest()->getContext()->getId();

        $recentIssuesWithCurrent = Repo::issue()->getCollector()
            ->filterByContextIds([$contextId])
            ->filterByPublished(true)
            ->limit(4)
            ->orderBy(Collector::ORDERBY_PUBLISHED_ISSUES)
            ->getMany();

        $currentIssue = Repo::issue()->getCurrent($contextId);

        // Exclude the current issue from the list
        $recentIssues = [];
        if ($currentIssue) {
            foreach ($recentIssuesWithCurrent as $issue) {
                if ($issue->getId() !== $currentIssue->getId()) {
                    $recentIssues[] = $issue;
                }
            }
        }

        $templateMgr->assign('recentIssues', $recentIssues);
    }


    /**
     * @param $hookname string
     * @param $args array
     */
    public function checkCurrentPage($hookname, $args)
    {
        $templateMgr = $args[0];
        // TODO check the issue with multiple calls of the hook on settings/website
        if (!isset($templateMgr->registered_plugins["function"]["pragma_item_active"])) {
            $templateMgr->registerPlugin('function', 'pragma_item_active', [$this, 'isActiveItem']);
        }
    }

    /**
     * @param $params array
     * @param $smarty Smarty_Internal_Template
     * @return string
     */
    public function isActiveItem($params, $smarty)
    {
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
        if ($navigationMenuItem->getIsChildVisible()) {
            return $emptyMarker;
        }

        // Retrieve URL and its components for a menu item
        $itemUrl = $navigationMenuItem->getUrl();

        // Check whether menu item points to the current page
        $context = $request->getContext();
        if ($context) {
            $currentIssue = Repo::issue()->getCurrent($context->getId());
            if ($navigationMenuItem->getType() === NavigationMenuService::NMI_TYPE_CURRENT) {
                $issue = $smarty->getTemplateVars('issue');
                if ($issue && ($issue->getId() === $currentIssue->getId()) && $currentPage == "issue") {
                    return $activeMarker;
                }
            }
        }

        if ($currentUrl === $itemUrl) {
            return $activeMarker;
        }

        return $emptyMarker;
    }
}
