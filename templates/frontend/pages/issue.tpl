{**
 * templates/frontend/pages/issue.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief Display a landing page for a single issue. It will show the table of contents
 *  (toc) or a cover image, with a click through to the toc.
 *
 * @uses $issue Issue The issue
 * @uses $issueIdentification string Label for this issue, consisting of one or
 *       more of the volume, number, year and title, depending on settings
 * @uses $issueGalleys array Galleys for the entire issue
 * @uses $primaryGenreIds array List of file genre IDs for primary types
 *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$issueIdentification}

<main class="container main__content" id="main">
	<section class="issue">

		{call_hook name="Templates::Index::journal"}

		{* Latest issue *}
		{if $issue}
			{include file="frontend/objects/issue_toc.tpl"}
		{/if}

	</section>

</main>

{include file="frontend/components/footer.tpl"}
