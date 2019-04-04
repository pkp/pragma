{**
 * templates/frontend/objects/issue_toc.tpl
 *
 * Copyright (c) 2014-2018 Simon Fraser University
 * Copyright (c) 2003-2018 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief View of an Issue which displays a full table of contents.
 *
 * @uses $issue Issue The issue
 * @uses $issueTitle string Title of the issue. May be empty
 * @uses $issueSeries string Vol/No/Year string for the issue
 * @uses $issueGalleys array Galleys for the entire issue
 * @uses $hasAccess bool Can this user access galleys for this context?
 * @uses $publishedArticles array Lists of articles published in this issue
 *   sorted by section.
 * @uses $primaryGenreIds array List of file genre ids for primary file types
 * @uses $sectionHeading string Tag to use (h2, h3, etc) for section headings
 *}

<div class="issue__header-wrapper">
	<div class="row">
		<header class="col-sm-6 issue__header">
			{if $requestedOp === "index"}
				<p class="issue__meta">{translate key="journal.currentIssue"}</p>
			{/if}
			{strip}
			<h{if $requestedOp === "issue"}1{else}2{/if} class="issue__title">
				{if $issue->getShowVolume() || $issue->getShowNumber()}
					{if $issue->getShowVolume()|escape}
						<span class="issue__volume">{translate key="issue.volume"} {$issue->getVolume()|escape}{if $issue->getShowNumber()}, {/if}</span>
					{/if}
					{if $issue->getShowNumber()}
						<span class="issue__number">{translate key="issue.no"}. {$issue->getNumber()|escape}. </span>
					{/if}
				{/if}
				{if $issue->getShowTitle()}
					<span class="issue__localized_name">{$issue->getLocalizedTitle()|escape}</span>
				{/if}
				</h1>
				{if $issue->getDatePublished()}
					<p class="issue__meta">{translate key="plugins.themes.immersion.issue.published"} {$issue->getDatePublished()|date_format:$dateFormatLong}</p>
				{/if}
				{if $issue->getLocalizedDescription()}
					<div class="issue-desc">
						{assign var=stringLenght value=280}
						{assign var=issueDescription value=$issue->getLocalizedDescription()|strip_unsafe_html}
						{if $issueDescription|strlen <= $stringLenght || $requestedPage == 'issue'}
							{$issueDescription}
						{else}
							{$issueDescription|substr:0:$stringLenght|mb_convert_encoding:'UTF-8'|replace:'?':''|trim}
							<span class="ellipsis">...</span>
							<p>
								<a class="btn btn-secondary"
								   href="{url op="view" page="issue" path=$issue->getBestIssueId()}">{translate key="plugins.themes.immersion.issue.fullIssueLink"}</a>
							</p>
						{/if}
					</div>
				{/if}
			{/strip}
		</header>
		{if $requestedPage != "issue" && $announcements}
			<div class="col-sm-6">
				<aside class="announcement-preview">
					<h2 class="issue__meta">{translate key="announcement.announcements"}</h2>
					<article>
						<h3 class="announcement-preview__title">{$announcements[0]->getLocalizedTitle()|escape}</h3>
						<p class="issue__meta">{$announcements[0]->getDatePosted()|date_format:$dateFormatLong}</p>
						<p>{$announcements[0]->getLocalizedDescriptionShort()}</p>
					</article>
				</aside>
			</div>
		{/if}
	</div>
</div>

{assign var=contentTableInserted value=false}
{foreach name=sections from=$publishedArticles item=section key=sectionNumber}
	{if $section.articles}
		<section class="issue-section">
			{if !$contentTableInserted}
				<hr/>
				<h3 class="issue-section__toc-title">Table of contents</h3>
				{assign var=contentTableInserted value=true}
			{/if}
			<header class="issue-section__header">
				<h3 class="issue-section__title">{$section.title|escape}</h3>
			</header>
			<ol class="issue-section__toc">
				{foreach from=$section.articles item=article}
					<li class="issue-section__toc-item">
						{include file="frontend/objects/article_summary.tpl"}
					</li>
				{/foreach}
			</ol>
		</section>
	{/if}
{/foreach}
