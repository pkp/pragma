{**
 * templates/frontend/objects/article_summary.tpl
 *
 * Copyright (c) 2014-2025 Simon Fraser University
 * Copyright (c) 2003-2025 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief View of an Article summary which is shown within a list of articles.
 *
 * @uses $article Article The article
 * @uses $authorUserGroups Traversible The set of author user groups
 * @uses $hasAccess bool Can this user access galleys for this context? The
 *       context may be an issue or an article
 * @uses $showDatePublished bool Show the date this article was published?
 * @uses $hideGalleys bool Hide the article galleys for this article?
 * @uses $primaryGenreIds array List of file genre ids for primary file types
 *}
{assign var="publication" value=$article->getCurrentPublication()}

{assign var=articlePath value=$publication->getData('urlPath')|default:$article->getId()}

{if (!$section.hideAuthor && $publication->getData('hideAuthor') == \APP\submission\Submission::AUTHOR_TOC_DEFAULT) || $publication->getData('hideAuthor') == \APP\submission\Submission::AUTHOR_TOC_SHOW}
	{assign var="showAuthor" value=true}
{/if}

<article class="row article">
	<div class="col-sm-{if $requestedPage == "catalog"}12{else}8{/if}">
		<h4 class="article__title">
			<a {if $journal}href="{url journal=$journal->getPath() page="article" op="view" path=$articlePath}"{else}href="{url page="article" op="view" path=$articlePath}"{/if}>
				{$publication->getLocalizedFullTitle(null, 'html')|strip_unsafe_html}
			</a>
		</h4>
		{if $showAuthor}
			<p class="metadata">{$publication->getAuthorString($authorUserGroups)|escape}</p>
		{/if}
		{call_hook name="Templates::Issue::Issue::Article"}
	</div>
	<div class="col-sm-4">
		{if !$hideGalleys}
			{foreach from=$article->getGalleys() item=galley}
				{if $primaryGenreIds}
					{assign var="file" value=$galley->getFile()}
					{if !$galley->getData('urlRemote') && !($file && in_array($file->getGenreId(), $primaryGenreIds))}
						{continue}
					{/if}
				{/if}
				{assign var="hasArticleAccess" value=$hasAccess}
				{if $currentContext->getSetting('publishingMode') == \APP\journal\Journal::PUBLISHING_MODE_OPEN || $publication->getData('accessStatus') == \APP\submission\Submission::ARTICLE_ACCESS_OPEN}
					{assign var="hasArticleAccess" value=1}
				{/if}
				{include file="frontend/objects/galley_link.tpl" parent=$article publication=$publication hasAccess=$hasArticleAccess purchaseFee=$currentJournal->getSetting('purchaseArticleFee') purchaseCurrency=$currentJournal->getSetting('currency')}
			{/foreach}
		{/if}
	</div>
</article>
