{**
 * templates/frontend/pages/indexJournal.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
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
 *}

{include file="frontend/components/header.tpl" pageTitleTranslated=$currentJournal->getLocalizedName()}

<main class="container main__content" id="main">
	{if $journalDescription or $announcements}
	<header class="row">
		{if $homepageImage}
		<figure style="background-color: {$baseColour};">
			<img src="{$publicFilesDir}/{$homepageImage.uploadName|escape:'url'}"{if $homepageImage.altText} alt="{$homepageImage.altText|escape}"{/if}
					 class="img-fluid"
					 style="mix-blend-mode: luminosity;"
			/>
			<hr/>
		</figure>
		{/if}
		{if $journalDescription}
			<div class="col-sm-6">
				<section class="journal-desc">
					<h2 class="metadata">{$displayPageHeaderTitle|escape}</h2>
					<article>
						<h3 class="journal-desc__title">{translate key="about.aboutContext"}</h3>
						{$journalDescription|strip_unsafe_html|truncate:450}
						<p>
							{capture assign="aboutPageUrl"}{url router=$smarty.const.ROUTE_PAGE page="about"}{/capture}
							<a href="{$aboutPageUrl}" class="btn btn-primary">{translate key="plugins.themes.pragma.more-info"}</a>
						</p>
					</article>
				</section>
			</div>
		{/if}

		{if $numAnnouncementsHomepage && $announcements|@count}
		<div class="col-sm-6">
			<aside class="announcement__content_boxed">
				<h2 class="metadata">{translate key="announcement.announcements"}</h2>
				{* Carousel *}
				<div id="announcementsCarouselControls" class="carousel slide" data-ride="carousel" data-interval="false">
					<div class="carousel-inner">
						{foreach name=announcements from=$announcements item=announcement}
							{if $smarty.foreach.announcements.iteration > $numAnnouncementsHomepage}
								{break}
							{/if}
							<article class="carousel-item{if $announcement@first} active{/if}">
									<h3 class="announcement__title_boxed">{$announcement->getLocalizedTitle()|escape}</h3>
									<p class="metadata">{$announcement->getDatePosted()|date_format:$dateFormatLong}</p>
									<p>{$announcement->getLocalizedDescriptionShort()|strip_unsafe_html}</p>
									<p>
										{capture assign="announcementPageUrl"}{url router=$smarty.const.ROUTE_PAGE page="announcement" op="view" path=$announcement->getId()}{/capture}
										<a href="{$announcementPageUrl}" class="btn btn-secondary">{translate key="common.more"}</a>
									</p>
								</article>
						{/foreach}
					</div>
					{if $numAnnouncementsHomepage > 1 && $announcements|@count > 1}
						{* Carousel controls *}
						<div class="text-right">
							<a href="#announcementsCarouselControls" class="btn" role="button" data-slide="prev">
								<span aria-hidden="true">←</span>
								<span class="sr-only">{translate key="help.next"}</span>
							</a>
							<a href="#announcementsCarouselControls" class="btn" role="button" data-slide="next">
								<span aria-hidden="true">→</span>
								<span class="sr-only">{translate key="help.previous"}</span>
							</a>
						</div>
					{/if}
				</div>
			</aside>
		</div>
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

	{* Recent issues *}
	{if ($recentIssues && !empty($recentIssues))}
		<hr/>
		<section class="recent-issues">
			<h3>{translate key="plugins.themes.pragma.issues.recent"}</h3>
			<div class="row">
				{foreach from=$recentIssues item=recentIssue}
					<article class="col-xs-6 col-md-3 recent-issues__item">
						<h4 class="recent-issues__issue-title">
							<a href="{url page='issue' op='view' path=$recentIssue->getBestIssueId()}">{$recentIssue->getIssueIdentification()|strip_unsafe_html}</a>
						</h4>
						<p class="metadata">{$recentIssue->getDatePublished()|date_format:$dateFormatLong}</p>
					</article>
				{/foreach}
			</div>
		</section>
	{/if}

	{* Additional Homepage Content *}
	{if $additionalHomeContent}
		<hr/>
		<section class="additional-content">
			<div class="row">
				<div class="col-sm-8">
					{$additionalHomeContent|strip_unsafe_html}
				</div>
			</div>
		</section>
	{/if}

</main>

{include file="frontend/components/footer.tpl"}
