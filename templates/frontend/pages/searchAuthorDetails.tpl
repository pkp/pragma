{**
 * templates/frontend/pages/searchAuthorDetails.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Index of published articles by author.
 *
 *}
{strip}
{assign var="pageTitle" value="search.authorDetails"}
{include file="frontend/components/header.tpl"}
{/strip}

<main class="container main__content" id="main">
	<div class="row">
		<div class="offset-md-1 col-md-10 offset-lg-2 col-lg-8">
			<header class="main__header">
				<h1 class="main__title">
					{$authorName|escape}
				</h1>
				{if $affiliation || $country}
					<h2 class="metadata">
						{$affiliation|escape} <br/>{$country|escape}
					</h2>
				{/if}
			</header>

			<section>
				{foreach from=$publishedSubmissions item=article}
					{assign var=issueId value=$article->getIssueId()}
					{assign var=issue value=$issues[$issueId]}
					{assign var=issueUnavailable value=$issuesUnavailable.$issueId}
					{assign var=sectionId value=$article->getSectionId()}
					{assign var=journalId value=$article->getJournalId()}
					{assign var=journal value=$journals[$journalId]}
					{assign var=section value=$sections[$sectionId]}
					{if $issue->getPublished() && $section && $journal}
						<article>
							<p class="metadata">
								<a href="{url journal=$journal->getPath() page="issue" op="view" path=$issue->getBestIssueId()}">{$journal->getLocalizedName()|escape} {$issue->getIssueIdentification()|strip_unsafe_html|nl2br}</a> ({$section->getLocalizedTitle()|escape})
							</p>

							<h3>{$article->getLocalizedTitle()|strip_unsafe_html}</h3>

							<p class="metadata">
								<a href="{url journal=$journal->getPath() page="article" op="view" path=$article->getBestArticleId()}" class="btn btn-secondary">{if $article->getLocalizedAbstract()}{translate key="article.abstract"}{else}{translate key="article.details"}{/if}</a>

								{if (!$issueUnavailable || $article->getAccessStatus() == $smarty.const.ARTICLE_ACCESS_OPEN)}
									{foreach from=$article->getGalleys() item=galley name=galleyList}
										&nbsp;<a href="{url journal=$journal->getPath() page="article" op="view" path=$article->getBestArticleId()|to_array:$galley->getBestGalleyId()}" class="btn btn-secondary">{$galley->getGalleyLabel()|escape}</a>
									{/foreach}
								{/if}
							</p>
						</article>
					{/if}
					<hr>
				{/foreach}
			</section>

		</div>
	</div>
</main>
{include file="frontend/components/footer.tpl"}
