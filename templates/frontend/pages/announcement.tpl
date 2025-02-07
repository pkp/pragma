{**
 * templates/frontend/pages/announcements.tpl
 *
 * Copyright (c) 2014-2025 Simon Fraser University
 * Copyright (c) 2003-2025 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief Display the page which represents a single announcement
 *
 * @uses $announcement Announcement The announcement to display
 *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$announcement->getLocalizedData('title')|escape}

<main class="container main__content" id="main">
	<div class="row">
		<div class="offset-md-1 col-md-10 offset-lg-2 col-lg-8">

			<article>
				<header class="main__header">
					<p class="metadata">{translate key="announcement.announcements"}</p>
					<h1 class="main__title">
						<span>{$announcement->getLocalizedData('title')|escape}</span>
					</h1>
				</header>
				<p>
					{$announcement->datePosted|date_format:$dateFormatShort}
				</p>
				<div>
					{if $announcement->getLocalizedData('description')}
						{$announcement->getLocalizedData('description')|strip_unsafe_html}
					{else}
						{$announcement->getLocalizedData('descriptionShort')|strip_unsafe_html}
					{/if}
				</div>
			</article>

		</div>
	</div>
</main>

{include file="frontend/components/footer.tpl"}
