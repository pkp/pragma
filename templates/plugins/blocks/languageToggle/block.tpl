{**
 * plugins/blocks/languageToggle/block.tpl
 *
 * Copyright (c) 2014-2018 Simon Fraser University
 * Copyright (c) 2003-2018 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
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
				<li class="locale_{$localeKey|escape}{if $localeKey == $currentLocale} current{/if}">
					<a href="{url router=$smarty.const.ROUTE_PAGE page="user" op="setLocale" path=$localeKey source=$smarty.server.REQUEST_URI}">
						{$localeName}
					</a>
				</li>
			{/foreach}
		</ul>
	</div>
</div>
{/if}
