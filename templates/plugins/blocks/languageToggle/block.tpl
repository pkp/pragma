{**
 * plugins/blocks/languageToggle/block.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * Common site sidebar menu -- language toggle.
 *}
{if $enableLanguageToggle}
<div class="col-md-3">
	<h2>
		{translate key="common.language"}
	</h2>

	<div>
		<ul>
			{foreach from=$languageToggleLocales item=localeName key=localeKey}
				<li class="locale_{$localeKey|escape}{if $localeKey == $currentLocale} current{/if}" lang="{$localeKey|replace:"_":"-"}">
					<a href="{url router=$smarty.const.ROUTE_PAGE page="user" op="setLocale" path=$localeKey}">
						{$localeName}
					</a>
				</li>
			{/foreach}
		</ul>
	</div>
</div>
{/if}
