{**
 * templates/frontend/objects/issue_summary.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief View of an Issue which displays a summary for use in lists
 *
 * @uses $issue Issue The issue
 *}
{if $issue->getShowTitle()}
{assign var=issueTitle value=$issue->getLocalizedTitle()}
{/if}
{assign var=issueSeries value=$issue->getIssueSeries()}
{assign var=issueCover value=$issue->getLocalizedCoverImageUrl()}

{if $issueCover}
	<a class="archived-issue__link" href="{url op="view" path=$issue->getBestIssueId()}">
		<img src="{$issueCover|escape}" alt="{$issue->getLocalizedCoverImageAltText()|escape|default:''}" class="img-fluid">
	</a>
{/if}

<a class="archived-issue__link" href="{url op="view" path=$issue->getBestIssueId()}">
	<h3 class="archived-issue__title">
		{if $issueTitle}
			{$issueTitle|escape}
		{else}
			{$issueSeries|escape}
		{/if}
	</h3>
</a>
{if $issueTitle && $issueSeries}
	<div class="archived-issue__series">
		{$issueSeries|escape}
	</div>
{/if}

<p class="metadata"><small>{$issue->getDatePublished()|date_format:$dateFormatLong}</small></p>
