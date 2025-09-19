<?php

/**
 * @file plugins/themes/pragma/PragmaPlugin.php
 *
 * Copyright (c) 2014-2025 Simon Fraser University
 * Copyright (c) 2003-2025 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class PragmaPlugin
 * @ingroup plugins_themes_pragma
 *
 * @brief Pragma theme
 */

namespace APP\plugins\themes\pragma;

use APP\facades\Repo;
use APP\issue\Collector;
use APP\services\NavigationMenuService;
use APP\template\TemplateManager;
use PKP\config\Config;
use PKP\core\PKPSessionGuard;
use PKP\facades\Locale;
use PKP\form\validation\FormValidatorAltcha;
use PKP\navigationMenu\NavigationMenuItem;
use PKP\plugins\Hook;
use PKP\plugins\ThemePlugin;
use Smarty_Internal_Template;

class PragmaPlugin extends ThemePlugin
{
    public function init(): void
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
                ['value' => 'none', 'label' => __('plugins.themes.pragma.option.displayStats.none')],
                ['value' => 'bar', 'label' => __('plugins.themes.pragma.option.displayStats.bar')],
                ['value' => 'line', 'label' => __('plugins.themes.pragma.option.displayStats.line')],
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
        $this->modifyStyle('stylesheet', ['addLessVariables' => implode("\n", $additionalLessVariables)]);

        // Adding scripts (JQuery, Popper, Bootstrap, JQuery UI, Tag-it, Theme's JS)
        $this->addScript('app-js', 'resources/dist/app.min.js');

        // Styles for HTML galleys
        $this->addStyle('htmlGalley', 'resources/less/import.less', ['contexts' => 'htmlGalley']);
        $this->modifyStyle('htmlGalley', ['addLessVariables' => implode("\n", $additionalLessVariables)]);

        Hook::add('TemplateManager::display', $this->initializeTemplate(...));
        Hook::add('TemplateManager::display', $this->addSiteWideData(...));
        Hook::add('TemplateManager::display', $this->addIndexJournalData(...));
        Hook::add('TemplateManager::display', $this->checkCurrentPage(...));
    }

    /**
     * Initialize Template
     *
     * @param array{TemplateManager,string,string} $args TemplateManager, &template, &output
     */
    public function initializeTemplate(string $hookName, array $args): bool
    {
        [$templateMgr] = $args;
        // The login link displays the login form in a modal, therefore the reCAPTCHA/ALTCHA must be available for all frontend routes
        $isCaptchaEnabled = Config::getVar('captcha', 'recaptcha') && Config::getVar('captcha', 'captcha_on_login');
        if ($isCaptchaEnabled) {
            $locale = substr(Locale::getLocale(), 0, 2);
            $templateMgr->addJavaScript('recaptcha', "https://www.recaptcha.net/recaptcha/api.js?hl={$locale}");
            $templateMgr->assign('recaptchaPublicKey', Config::getVar('captcha', 'recaptcha_public_key'));
        }

        $isAltchaEnabled = Config::getVar('captcha', 'altcha') && Config::getVar('captcha', 'altcha_on_login');
        if ($isAltchaEnabled) {
            FormValidatorAltcha::addAltchaJavascript($templateMgr);
            FormValidatorAltcha::insertFormChallenge($templateMgr);
        }

        return Hook::CONTINUE;
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
     * Add site wide data to the template
     *
     * @param array{TemplateManager,string,string} $args TemplateManager, &template, &output
     */
    public function addSiteWideData(string $hookName, array $args): bool
    {
        [$templateMgr] = $args;

        $request = $this->getRequest();
        $journal = $request->getContext();
        $baseColour = $this->getOption('baseColour');

        if (PKPSessionGuard::isSessionDisable()) {
            return Hook::CONTINUE;
        }

        // Check locales
        $locales = $journal ? $journal->getSupportedLocaleNames() : $request->getSite()->getSupportedLocaleNames();

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
        return Hook::CONTINUE;
    }

    /**
     * Add index journal data to the template
     *
     * @param array{TemplateManager,string,string} $args TemplateManager, &template, &output
     */
    public function addIndexJournalData(string $hookName, array $args): bool
    {
        [$templateMgr, $template] = $args;

        if ($template !== 'frontend/pages/indexJournal.tpl') {
            return Hook::CONTINUE;
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
        return Hook::CONTINUE;
    }


    /**
     * Check current page
     *
     * @param array{TemplateManager,string,string} $args TemplateManager, &template, &output
     */
    public function checkCurrentPage(string $hookName, array $args): bool
    {
        [$templateMgr] = $args;
        // TODO check the issue with multiple calls of the hook on settings/website
        if (!isset($templateMgr->registered_plugins["function"]["pragma_item_active"])) {
            $templateMgr->registerPlugin('function', 'pragma_item_active', $this->isActiveItem(...));
        }
        return Hook::CONTINUE;
    }

    /**
     * Check if the item is active
     *
     * @param array{item: NavigationMenuItem} $params
     */
    public function isActiveItem(array $params, Smarty_Internal_Template $smarty)
    {
        $navigationMenuItem = $params['item'];
        $emptyMarker = '';
        $activeMarker = ' active';

        // Get URL of the current page
        $request = $this->getRequest();
        $currentUrl = $request->getCompleteUrl();
        $currentPage = $request->getRequestedPage();

        if (!($navigationMenuItem instanceof NavigationMenuItem && $navigationMenuItem->getIsDisplayed())) {
            if (!is_string($navigationMenuItem)) {
                return $emptyMarker;
            }

            $navigationMenuItemIndex = preg_replace('/index$/', '', $navigationMenuItem);
            $navigationMenuItemSlash = preg_replace('/\/index$/', '', $navigationMenuItem);
            return $navigationMenuItem == $currentUrl || $navigationMenuItemIndex == $currentUrl || $navigationMenuItemSlash == $currentUrl
                ? $activeMarker
                : $emptyMarker;
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

class_alias(PragmaPlugin::class, 'PragmaThemePlugin');
class_alias(PragmaPlugin::class, 'APP\plugins\themes\pragma\PragmaThemePlugin');
