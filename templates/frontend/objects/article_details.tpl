{**
 * templates/frontend/objects/article_details.tpl
 *
 * Copyright (c) 2014-2018 Simon Fraser University
 * Copyright (c) 2003-2018 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief View of an Article which displays all details about the article.
 *  Expected to be primary object on the page.
 *
 * Core components are produced manually below. Additional components can added
 * via plugins using the hooks provided:
 *
 * Templates::Article::Main
 * Templates::Article::Details
 *
 * @uses $article Article This article
 * @uses $issue Issue The issue this article is assigned to
 * @uses $section Section The journal section this article is assigned to
 * @uses $primaryGalleys array List of article galleys that are not supplementary or dependent
 * @uses $supplementaryGalleys array List of article galleys that are supplementary
 * @uses $keywords array List of keywords assigned to this article
 * @uses $pubIdPlugins Array of pubId plugins which this article may be assigned
 * @uses $copyright string Copyright notice. Only assigned if statement should
 *   be included with published articles.
 * @uses $copyrightHolder string Name of copyright holder
 * @uses $copyrightYear string Year of copyright
 * @uses $licenseUrl string URL to license. Only assigned if license should be
 *   included with published articles.
 * @uses $ccLicenseBadge string An image and text with details about the license
 *}

<article>
	<header class="row main__header">
		<div class="col-md-9">
			{* Issue title & section *}
			<p class="metadata">
				<a href="{url page="issue" op="view" path=$issue->getBestIssueId()}">{$issue->getIssueSeries()|escape}</a>
				{if $section}<br>{$section->getLocalizedTitle()|escape}</span>{/if}
			</p>

			{* Article title *}
			<h1 class="main__title">
				{$article->getLocalizedFullTitle()|escape}
			</h1>

			{* DOI *}
			{foreach from=$pubIdPlugins item=pubIdPlugin}
				{if $pubIdPlugin->getPubIdType() != 'doi'}
					{continue}
				{/if}
				{assign var=pubId value=$article->getStoredPubId($pubIdPlugin->getPubIdType())}
				{if $pubId}
					{assign var="doiUrl" value=$pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}
					<p class="metadata">
						<a href="{$doiUrl}">{$doiUrl}</a>
					</p>
				{/if}
			{/foreach}

			{* Date published *}
			{if $article->getDatePublished()}
				<p class="metadata">
					{translate key="plugins.themes.healthSciences.currentIssuePublished" date=$article->getDatePublished()|date_format:$dateFormatLong}
				</p>
			{/if}

			{* Authors *}
			{if $article->getAuthors()}
				<ul class="metadata">
					{assign var="authors" value=$article->getAuthors()}
					{foreach from=$authors name=authors item=authorString key=authorStringKey}
						{strip}
							<li>
								<a data-toggle="collapse" href="#author-{$authorStringKey}" role="button" aria-expanded="false">
									<span>{$authorString->getFullName()|escape}</span>
								</a>
								{if $authorString->getOrcid()}
									<a href="{$authorString->getOrcid()|escape}"><img src="{$baseUrl}/{$orcidImage}"></a>
								{/if}
							</li>
						{/strip}{if !$smarty.foreach.authors.last}, {/if}
					{/foreach}
				</ul>

				{* Affiliations *}
				{assign var="authorCount" value=$authors|@count}
				{assign var="authorBioIndex" value=0}
				{foreach from=$authors item=author key=authorKey}
					<div class="collapse" id="author-{$authorStringKey}">
						{if $author->getLocalizedAffiliation()}
							<div>{$author->getLocalizedAffiliation()|escape}</div>
						{/if}
						{if $author->getOrcid()}
							<div>
								<a href="{$author->getOrcid()|escape}" target="_blank">
									{$orcidIcon}
									{$author->getOrcid()|escape}
								</a>
							</div>
						{/if}
					</div>
				{/foreach}
			{/if}
		</div>

		<section class="col-md-3">
			{* Article or issue cover image *}
			{if $article->getLocalizedCoverImage() || $issue->getLocalizedCoverImage()}
				{if $article->getLocalizedCoverImage()}
					<img class="img-fluid" src="{$article->getLocalizedCoverImageUrl()|escape}"{if $article->getLocalizedCoverImageAltText()} alt="{$article->getLocalizedCoverImageAltText()|escape}"{/if}>
				{else}
					<a href="{url page="issue" op="view" path=$issue->getBestIssueId()}">
						<img class="img-fluid" src="{$issue->getLocalizedCoverImageUrl()|escape}"{if $issue->getLocalizedCoverImageAltText()} alt="{$issue->getLocalizedCoverImageAltText()|escape}"{/if}>
					</a>
				{/if}
			{/if}
		</section>
	</header>

	<div class="row" id="mainArticleContent">
		<aside class="col-lg-3 order-lg-2">
			{* How to cite *}
			{if $citation}
				<section>
					<h2>{translate key="submission.howToCite"}</h2>
					<div id="citationOutput" class="article-details-how-to-cite-citation" role="region" aria-live="polite">
						{$citation}
					</div>
					<div class="dropdown">
						<button class="btn btn-primary dropdown-toggle" type="button" id="cslCitationFormatsButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" data-csl-dropdown="true">
							{translate key="submission.howToCite.citationFormats"}
						</button>
						<div class="dropdown-menu" aria-labelledby="cslCitationFormatsButton">
							{foreach from=$citationStyles item="citationStyle"}
								<a
									class="dropdown-item"
									aria-controls="citationOutput"
									href="{url page="citationstylelanguage" op="get" path=$citationStyle.id params=$citationArgs}"
									data-load-citation
									data-json-href="{url page="citationstylelanguage" op="get" path=$citationStyle.id params=$citationArgsJson}"
								>
									{$citationStyle.title|escape}
								</a>
							{/foreach}
							{if count($citationDownloads)}
								<h3 class="dropdown-header">
									{translate key="submission.howToCite.downloadCitation"}
								</h3>
								{foreach from=$citationDownloads item="citationDownload"}
									<a class="dropdown-item" href="{url page="citationstylelanguage" op="download" path=$citationDownload.id params=$citationArgs}">
										{$citationDownload.title|escape}
									</a>
								{/foreach}
							{/if}
						</div>
					</div>
				</section>
			{/if}

			{call_hook name="Templates::Article::Details"}
		</aside>

		<div class="col-lg-9 order-lg-1" id="articleMainWrapper">
			<div class="article-details-main" id="articleMain">

				{* PubIds (other than DOI; requires plugins) *}
				{foreach from=$pubIdPlugins item=pubIdPlugin}
					{if $pubIdPlugin->getPubIdType() == 'doi'}
						{continue}
					{/if}
					{assign var=pubId value=$article->getStoredPubId($pubIdPlugin->getPubIdType())}
					{if $pubId}
						<section class="metadata">
							<h2>
								{$pubIdPlugin->getPubIdDisplayType()|escape}
							</h2>
							<div>
								{if $pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}
									<a id="pub-id::{$pubIdPlugin->getPubIdType()|escape}" href="{$pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}">
										{$pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}
									</a>
								{else}
									{$pubId|escape}
								{/if}
							</div>
						</section>
					{/if}
				{/foreach}

				{* Abstract *}
				{if $article->getLocalizedAbstract()}
					<section>
						<h2>{translate key="article.abstract"}</h2>
						{$article->getLocalizedAbstract()|strip_unsafe_html}
					</section>
				{/if}

				{* Keywords *}
				{if !empty($keywords[$currentLocale])}
					<section>
						<h2>
							{translate key="article.subject"}
						</h2>
						<p>
							{foreach from=$keywords item=keyword}
								{foreach name=keywords from=$keyword item=keywordItem}
									<span>{$keywordItem|escape}</span>{if !$smarty.foreach.keywords.last}, {/if}
								{/foreach}
							{/foreach}
						</p>
					</section>
				{/if}

				{* Article galleys *}
				{if $primaryGalleys}
					<section>
						{foreach from=$primaryGalleys item=galley}
							{include file="frontend/objects/galley_link.tpl" parent=$article galley=$galley purchaseFee=$currentJournal->getSetting('purchaseArticleFee') purchaseCurrency=$currentJournal->getSetting('currency')}
						{/foreach}
					</section>
				{/if}

				{* Supplementary galleys *}
				{if $supplementaryGalleys}
					<section>
						<h2>{translate key="article.suppFiles"}</h2>
						{foreach from=$supplementaryGalleys item=galley}
							{include file="frontend/objects/galley_link.tpl" parent=$article galley=$galley isSupplementary="1"}
						{/foreach}
					</section>
				{/if}

				{* Author biographies *}
				<section>
					<h2>{translate key="about.editorialTeam.biography"}</h2>
					{foreach from=$article->getAuthors() item=author key=authorKey}
						{if $author->getLocalizedBiography()}
							<h3>{$author->getFullName()|escape}</h3>
							<p>{$author->getLocalizedBiography()|strip_unsafe_html}</p>
						{/if}
					{/foreach}
				</section>

				{* References *}
				{if $parsedCitations->getCount() || $article->getCitations()}
					<hr>
					<section>
						<h2>
							{translate key="submission.citations"}
						</h2>
						<ol>
							{if $parsedCitations->getCount()}
								{iterate from=parsedCitations item=parsedCitation}
									<li>{$parsedCitation->getCitationWithLinks()|strip_unsafe_html}</li>
								{/iterate}
							{elseif $article->getCitations()}
								{$article->getCitations()|nl2br}
							{/if}
						</ol>
					</section>
				{/if}

				{* Licensing info *}
				{if $copyright || $licenseUrl}
					<section>
						{if $licenseUrl}
							{if $ccLicenseBadge}
								{$ccLicenseBadge}
							{else}
								<a href="{$licenseUrl|escape}">
									{if $copyrightHolder}
										{translate key="submission.copyrightStatement" copyrightHolder=$copyrightHolder|escape copyrightYear=$copyrightYear|escape}
									{else}
										{translate key="submission.license"}
									{/if}
								</a>
							{/if}
						{else}
							{$copyright}
						{/if}
					</section>
				{/if}

				{call_hook name="Templates::Article::Main"}
			</div>
		</div>

		<div class="col-lg-12 order-lg-3 article-footer-hook">
			{call_hook name="Templates::Article::Footer::PageFooter"}
		</div>

	</div>
</article>
