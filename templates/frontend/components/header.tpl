{**
 * templates/frontend/components/header.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief Site-wide header; includes journal logo, user menu, and primary menu
 * @uses $languageToggleLocales array All supported locales (from the Immersion theme)
 *}

{strip}
	{* Determine whether a logo or title string is being displayed *}
	{assign var="showingLogo" value=true}
	{if !$displayPageHeaderLogo}
		{assign var="showingLogo" value=false}
	{/if}
	{assign var="localeShow" value=false}
	{if $languageToggleLocales && $languageToggleLocales|@count > 1}
		{assign var="localeShow" value=true}
	{/if}
{/strip}

<!DOCTYPE html>

<html lang="{$currentLocale|replace:"_":"-"}" xml:lang="{$currentLocale|replace:"_":"-"}">
{if !$pageTitleTranslated}{capture assign="pageTitleTranslated"}{translate key=$pageTitle}{/capture}{/if}
{include file="frontend/components/headerHead.tpl"}
<body class="page_{$requestedPage|escape|default:"index"} op_{$requestedOp|escape|default:"index"}{if $showingLogo} has_site_logo{/if}"
      dir="{$currentLocaleLangDir|escape|default:"ltr"}">

	<div>
		<a class="sr-only" href="#pragma_content_header">{translate key="navigation.skip.nav"}</a>
		<a class="sr-only" href="#main">{translate key="navigation.skip.main"}</a>
		<a class="sr-only" href="#pragma_content_footer">{translate key="navigation.skip.footer"}</a>
	</div>

	<header class="container-fluid main-header" id="pragma_content_header">
		<nav class="main-header__admin main-header__admin{if $localeShow}_locale-enabled{else}_locale-disabled{/if}">

			{* User navigation *}
			{capture assign="userMenu"}
				{load_menu name="user" id="navigationUser" ulClass="pkp_navigation_user" liClass="profile"}
			{/capture}

			{* language toggle block *}
			{if $localeShow}
				{include file="frontend/components/languageSwitcher.tpl" id="languageNav"}
			{/if}

			{if !empty(trim($userMenu))}
				<h2 class="sr-only">{translate key="plugins.themes.pragma.adminMenu"}</h2>
				{$userMenu}
			{/if}

		</nav>

		<nav class="navbar navbar-expand-lg main-menu">
			{if $requestedOp == 'index'}
				<h1 class="main-menu__title">
			{else}
				<div class="main-menu__title">
			{/if}

			{capture assign="homeUrl"}
				{url page="index" router=$smarty.const.ROUTE_PAGE}
			{/capture}
			{if $displayPageHeaderLogo}
				<a href="{$homeUrl}">
					<img src="{$publicFilesDir}/{$displayPageHeaderLogo.uploadName|escape:"url"}" width="{$displayPageHeaderLogo.width|escape}" height="{$displayPageHeaderLogo.height|escape}" {if $displayPageHeaderLogo.altText != ''}alt="{$displayPageHeaderLogo.altText|escape}"{else}alt="{translate key="common.pageHeaderLogo.altText"}"{/if}
					class="img-fluid"/>
				</a>
			{elseif $displayPageHeaderTitle}
				<a href="{$homeUrl}">
					<span>{$displayPageHeaderTitle|escape}</span>
				</a>
			{else}
				<a href="{$homeUrl}">
					<img src="{$baseUrl}/templates/images/structure/logo.png" alt="{$applicationName|escape}" title="{$applicationName|escape}" width="180" height="90" class="img-fluid"/>
				</a>
			{/if}

			{if $requestedOp == 'index'}
				</h1>
			{else}
				</div>
			{/if}

			{* Primary navigation *}
			{capture assign="primaryMenu"}
				{load_menu name="primary" id="navigationPrimary" ulClass="pkp_navigation_primary"}
			{/capture}

			{if !empty(trim($primaryMenu)) || $currentContext}
				<button class="navbar-toggler hamburger" data-target="#mainMenu" data-toggle="collapse"
						type="button"
						aria-label="Menu" aria-controls="navigation">
					<span class="hamburger__wrapper">
						<span class="hamburger__icon"></span>
					</span>
				</button>

				<div class="collapse navbar-collapse main-menu__nav" id="mainMenu">
					{$primaryMenu}
				</div>
			{/if}
		</nav>
	</header>
