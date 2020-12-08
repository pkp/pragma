{**
 * templates/frontend/pages/announcements.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief Display the page to view the latest announcements
 *
 * @uses $announcements array List of announcements
 *}
{include file="frontend/components/header.tpl" pageTitle="announcement.announcements"}

<main class="container main__content" id="main">
	<div class="row">
		<section class="offset-md-1 col-md-10 offset-lg-2 col-lg-8 announcements__toc">
			<header class="main__header">
				<h1 class="main__title">
					<span>{translate key="announcement.announcements"}</span>
				</h1>
				{include file="frontend/components/editLink.tpl" page="management" op="settings" path="announcements" anchor="announcements" sectionTitleKey="announcement.announcements"}
			</header>

			{$announcementsIntroduction|strip_unsafe_html}

			{foreach from=$announcements item=announcement}
				<article class="announcement">
					{include file="frontend/objects/announcement_summary.tpl"}
				</article>
				{if !$item@last}<hr>{/if}
			{/foreach}
		</section>
	</div>
</main>

{include file="frontend/components/footer.tpl"}
