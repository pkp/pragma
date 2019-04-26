{**
 * templates/frontend/pages/indexJournal.tpl
 *
 * Copyright (c) 2014-2018 Simon Fraser University
 * Copyright (c) 2003-2018 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief Display the index page for a journal
 *
 * @uses $currentJournal Journal This journal
 * @uses $journalDescription string Journal description from HTML text editor
 * @uses $homepageImage object Image to be displayed on the homepage
 * @uses $additionalHomeContent string Arbitrary input from HTML text editor
 * @uses $announcements array List of announcements
 * @uses $numAnnouncementsHomepage int Number of announcements to display on the
 *       homepage
 * @uses $issue Issue Current issue
 * @uses $issueIdentificationString string issue identification that relies on user's settings
 * @uses $lastSectionColor string background color of the last section presented on the index page
 * @uses $immersionAnnouncementsColor string background color of the announcements section
 *}

{include file="frontend/components/header.tpl" pageTitleTranslated=$currentJournal->getLocalizedName()}

<main class="container main__content" id="main">
	{if $journalDescription or $announcements}
	<header class="row">
		{if $journalDescription}
			<section class="col-sm-6 journal-desc">
				<h2 class="metadata">{$displayPageHeaderTitle}</h2>
				<article>
					<h3 class="journal-desc__title">{translate key="about.aboutContext"}</h3>
					{$journalDescription|strip_unsafe_html|truncate:450}
					<p>
						{capture assign="aboutPageUrl"}{url router=$smarty.const.ROUTE_PAGE page="about"}{/capture}
						<a href="{$aboutPageUrl}" class="btn btn-primary">{translate key="plugins.themes.pragma.more-info"}</a>
					</p>
				</article>
			</section>
		{/if}
		{if $announcements}
		{* Display only single latest announcement *}
			<aside class="col-sm-6 announcement-preview">
				<h2 class="metadata">{translate key="announcement.announcements"}</h2>
				<article>
					<h3 class="announcement-preview__title">{$announcements[0]->getLocalizedTitle()|escape}</h3>
					<p class="metadata">{$announcements[0]->getDatePosted()|date_format:$dateFormatLong}</p>
					<p>{$announcements[0]->getLocalizedDescriptionShort()}</p>
					<p>
						{capture assign="announcementPageUrl"}{url router=$smarty.const.ROUTE_PAGE page="announcement" op="view" path=$announcements[0]->getId()}{/capture}
						<a href="{$announcementPageUrl}" class="btn btn-secondary">{translate key="common.more"}</a>
					</p>
				</article>
			</aside>
		{/if}
	</header>
	{/if}
	<section class="issue">

		{call_hook name="Templates::Index::journal"}

		{* Latest issue *}
		{if $issue}
			{include file="frontend/objects/issue_toc.tpl"}
		{/if}

	</section>

	{* Additional Homepage Content *}
	{if $additionalHomeContent}
		<section class="recent-issues">
			<hr/>
			<div class="row">
				<div class="col-sm-8">
					{$additionalHomeContent|strip_unsafe_html}
				</div>
			</div>
		</section>
	{/if}

	{if ($recentIssues && !empty($recentIssues))}
		<section class="recent-issues">
			<hr/>
			<h2 class="recent-issues__title">{translate key="plugins.themes.pragma.issues.recent"}</h2>
			<div class="row">
				{foreach from=$recentIssues item=recentIssue}
					<article class="col-xs-6 col-md-3 recent-issues__item">
						<h3 class="recent-issues__issue-title">
							<a href="issue.html">{$recentIssue->getIssueIdentification()}</a>
						</h3>
						<p class="recent-issues__meta">{$recentIssue->getDatePublished()|date_format:$dateFormatLong}</p>
					</article>
				{/foreach}
			</div>
		</section>
	{/if}

</main><!-- .page -->

{include file="frontend/components/footer.tpl"}
