{**
 * templates/frontend/pages/announcements.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief Display the page which represents a single announcement
 *
 * @uses $announcement Announcement The announcement to display
 *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$announcement->getLocalizedTitle()|escape}

<main class="container main__content" id="main">
	<div class="row">
		<div class="offset-md-1 col-md-10 offset-lg-2 col-lg-8">

			<article>
				<header class="main__header">
					<p class="metadata">{translate key="announcement.announcements"}</p>
					<h1 class="main__title">
						<span>{$announcement->getLocalizedTitle()|escape}</span>
					</h1>
				</header>
				<p>
					{$announcement->getDatePosted()|date_format:$dateFormatShort}
				</p>
				<div>
					{if $announcement->getLocalizedDescription()}
						{$announcement->getLocalizedDescription()|strip_unsafe_html}
					{else}
						{$announcement->getLocalizedDescriptionShort()|strip_unsafe_html}
					{/if}
				</div>
			</article>

		</div>
	</div>
</main>

{include file="frontend/components/footer.tpl"}
