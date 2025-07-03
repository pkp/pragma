{**
 * templates/frontend/objects/announcement_summary.tpl
 *
 * Copyright (c) 2014-2025 Simon Fraser University
 * Copyright (c) 2003-2025 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Display a summary view of an announcement
 *
 * @uses $announcement Announcement The announcement to display
 * @uses $heading string HTML heading element, default: h2
 *}
{if !$heading}
	{assign var="heading" value="h2"}
{/if}

<{$heading}>
	<a href="{url router=$smarty.const.ROUTE_PAGE page="announcement" op="view" path=$announcement->id}">
		{$announcement->getLocalizedData('title')|escape}
	</a>
</{$heading}>
<div class="announcement__date">
	{$announcement->datePosted|date_format:$dateFormatShort}
</div>
<div class="announcement__desc">
	{$announcement->getLocalizedData('descriptionShort')|strip_unsafe_html}
</div>
<a href="{url router=$smarty.const.ROUTE_PAGE page="announcement" op="view" path=$announcement->id}" class="btn btn-secondary">
	<span aria-hidden="true" role="presentation">
		{translate key="common.readMore"}
	</span>
	<span class="visually-hidden">
		{translate key="common.readMoreWithTitle" title=$announcement->getLocalizedData('title')|escape}
	</span>
</a>
