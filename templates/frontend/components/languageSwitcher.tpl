{**
 * templates/frontend/components/languageSwitcher.tpl
 *
 * Copyright (c) 2014-2025 Simon Fraser University
 * Copyright (c) 2003-2025 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief A re-usable template for displaying a language switcher dropdown.
 *
 * @uses $currentLocale string Locale key for the locale being displayed
 * @uses $languageToggleLocales array All supported locales
 * @uses $id string A unique ID for this language toggle
 *}

<div class="dropdown">
  <a class="dropdown-toggle main-header__nav-link" href="#" role="button" id="languageToggleMenu{$id|escape}" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
		<span class="visually-hidden">{translate key="common.language"}</span>
		{$languageToggleLocales[$currentLocale]|escape}
  </a>

  <ul class="dropdown-menu" aria-labelledby="languageToggleMenu{$id|escape}">
		{foreach from=$languageToggleLocales item=localeName key=localeKey}
			{if $localeKey !== $currentLocale}
				<li class="dropdown-item" lang="{$localeKey|escape}">
					<a href="{url router=$smarty.const.ROUTE_PAGE page="user" op="setLocale" path=$localeKey}">
						{$localeName|escape}
					</a>
				</li>
			{/if}
		{/foreach}
  </ul>
</div>
