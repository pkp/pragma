{**
 * templates/frontend/pages/issue.tpl
 *
 * Copyright (c) 2014-2019 Simon Fraser University
 * Copyright (c) 2003-2019 John Willinsky
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
	{if $journalDescription}
		<section class="journal-desc">
			<h2 class="journal-desc__title">About this journal</h2>
			<div class="row">
				<div class="col-sm-8 journal-desc__content">
					{$journalDescription|strip_unsafe_html}
				</div>
			</div>
			{capture assign="aboutPageUrl"}{url router=$smarty.const.ROUTE_PAGE page="about"}{/capture}
			<p><a href="{$aboutPageUrl}" class="btn btn-primary">{translate key="plugins.themes.pragma.more-info"}</a>
			</p>
		</section>
	{/if}
	<section class="issue">

		{call_hook name="Templates::Index::journal"}

		{* Latest issue *}
		{if $issue}
			{include file="frontend/objects/issue_toc.tpl"}
		{/if}

	</section>

</main>

{include file="frontend/components/footer.tpl"}
